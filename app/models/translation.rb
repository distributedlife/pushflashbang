# -*- encoding : utf-8 -*-
class Translation < ActiveRecord::Base
  belongs_to :languages, :class_name => "Language", :foreign_key => "language_id"
  
  has_attached_file :audio,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "audio/:id/#{Digest::MD5::hexdigest(":id").upcase}.:extension"

  attr_accessible :language_id, :form, :pronunciation, :audio, :t_type, :idiom_id

  validates :language_id, :presence => true
  validates :idiom_id, :presence => true
  validates :form, :presence => true
  validates_attachment_size :audio, :less_than => 1.megabytes,  :unless => Proc.new {|model| model.audio }

  def delete
    self.audio.destroy unless self.audio.file?

    RelatedTranslations.where(:translation1_id => self.id).each do |rt|
      rt.delete
    end
    RelatedTranslations.where(:translation2_id => self.id).each do |rt|
      rt.delete
    end

    return super
  end

  def self.get_sorted_selection idioms
    Translation.joins(:languages).order("idiom_id asc").order("name asc").order("form asc").where(:idiom_id => idioms, :languages => {:enabled => true})
  end

  def self.all_sorted_by_idiom_language_and_form_with_like_filter filter, page = 1, limit = Rails.application.config.search_page_size
    if filter.kind_of? Array
      filter_string = "(%#{filter.join('%|%')}%)"
    else
      filter_string = "(%#{filter.strip}%)"
    end
    filter_string.downcase!

    where = <<-SQL
      id IN
      (
        SELECT t.idiom_id
        FROM translations t
        INNER JOIN languages l
        ON t.language_id = l.id AND l.enabled = true
        WHERE lower(t.form) SIMILAR TO :filter
        OR lower(t.pronunciation) SIMILAR TO :filter
      )
    SQL

    offset = (page - 1) * limit
    offset = 0 if offset < 0

    idioms = Idiom.order("id asc").where(where, :filter => filter_string).limit(limit).offset(offset)
    self.get_sorted_selection idioms
  end

  def self.all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set_id, filter, page = 1, limit = Rails.application.config.search_page_size
    if filter.kind_of? Array
      filter_string = "(%#{filter.join('%|%')}%)"
    else
      filter_string = "(%#{filter.strip}%)"
    end
    filter_string.downcase!

    terms_matching_filter = <<-SQL
      SELECT t.idiom_id
      FROM translations t
      WHERE lower(t.form) SIMILAR TO :filter
      OR lower(t.pronunciation) SIMILAR TO :filter
    SQL
    terms_already_in_set = <<-SQL
      SELECT term_id
      FROM set_terms
      WHERE set_terms.set_id = :set_id
    SQL

    where = <<-SQL
      id IN
      (
        #{terms_matching_filter}
        EXCEPT
        #{terms_already_in_set}
      )
    SQL

    offset = (page - 1) * limit
    offset = 0 if offset < 0

    idioms = Idiom.order("id asc").where(where, :filter => filter_string, :set_id => set_id).limit(limit).offset(offset)
    self.get_sorted_selection idioms
  end

  def self.all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter filter, page = 1, limit = Rails.application.config.search_page_size
    if filter.kind_of? Array
      filter_string = "(%#{filter.join('%|%')}%)"
    else
      filter_string = "(%#{filter.strip}%)"
    end
    filter_string.downcase!

    terms_matching_filter = <<-SQL
      SELECT t.idiom_id
      FROM translations t
      WHERE lower(t.form) SIMILAR TO :filter
      OR lower(t.pronunciation) SIMILAR TO :filter
    SQL
    terms_already_in_set = <<-SQL
      SELECT term_id
      FROM set_terms
    SQL

    where = <<-SQL
      id IN
      (
        #{terms_matching_filter}
        EXCEPT
        #{terms_already_in_set}
      )
    SQL

    offset = (page - 1) * limit
    offset = 0 if offset < 0

    idioms = Idiom.order("id asc").where(where, :filter => filter_string).limit(limit).offset(offset)
    self.get_sorted_selection idioms
  end

  def self.remove_duplicates
    identical_sql = <<-SQL
      SELECT form, language_id, idiom_id, pronunciation, count(*)
      FROM translations
      GROUP BY form, language_id, idiom_id, pronunciation
      HAVING count(*) > 1
    SQL

    identical = ActiveRecord::Base.connection.execute(identical_sql)
    puts "#{identical.count} duplicates found"

    
    identical.each do |record|
      identical_translations = Translation.where(:form => record["form"], :language_id => record["language_id"], :idiom_id => record["idiom_id"], :t_type => record["t_type"])
        identical_translations.each_with_index do |translation, index|
        next if index == 0 #we need to keep one

        translation.delete
      end
    end
  end

  def should_be_ignored_during_creation?
    self.language_id.nil? and self.form.blank? and self.pronunciation.blank?
  end

  def update_idiom! idiom_id
    self.idiom_id = idiom_id
    self.save!
  end
end
