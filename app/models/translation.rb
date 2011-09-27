class Translation < ActiveRecord::Base
  belongs_to :languages, :class_name => "Language", :foreign_key => "language_id"
  
#  has_paper_trail
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

    return super
  end

  def self.all_sorted_by_idiom_language_and_form
    Translation.joins(:languages).order(:idiom_id).order(:name).order(:form).all
  end

  def self.all_sorted_by_idiom_language_and_form_with_like_filter filter, limit, offset
    filter_string = "(%#{filter.join('%|%')}%)"
    filter_string.downcase!

    where = <<-SQL
      id IN
      (
        SELECT t.idiom_id
        FROM translations t
        WHERE lower(t.form) SIMILAR TO :filter
        OR lower(t.pronunciation) SIMILAR TO :filter
      )
    SQL

    idioms = Idiom.where(where, :filter => filter_string).limit(limit).offset(offset)
    Translation.joins(:languages).order(:idiom_id).order(:name).order(:form).where(:idiom_id => idioms)
  end

  def self.all_in_set_sorted_by_idiom_language_and_form_with_like_filter set_id, filter, limit, offset
    filter_string = "(%#{filter.join('%|%')}%)"
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

    idioms = Idiom.where(where, :filter => filter_string, :set_id => set_id).limit(limit).offset(offset)
    Translation.joins(:languages).order(:idiom_id).order(:name).order(:form).where(:idiom_id => idioms)
  end
end