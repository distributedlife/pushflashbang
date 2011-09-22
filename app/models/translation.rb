class Translation < ActiveRecord::Base
  belongs_to :languages, :class_name => "Language", :foreign_key => "language_id"
  belongs_to :idiom_translations, :class_name => "IdiomTranslation", :foreign_key => "id", :primary_key => "translation_id"
  
  has_paper_trail
  has_attached_file :audio,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "audio/:id/#{Digest::MD5::hexdigest(":id").upcase}.:extension"

  attr_accessible :language_id, :form, :pronunciation, :audio, :t_type

  validates :language_id, :presence => true
  validates :form, :presence => true
  validates_attachment_size :audio, :less_than => 1.megabytes,  :unless => Proc.new {|model| model.audio }

  def delete
    self.audio.destroy unless self.audio.file?

    return super
  end

  def self.all_sorted_by_idiom_language_and_form
    Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).all
  end

  def self.all_sorted_by_idiom_language_and_form_with_like_filter filter
    filter_string = "(%#{filter.join('%|%')}%)"

    where = <<-SQL
      idiom_translations.idiom_id IN
      (
        SELECT idiom_id
        FROM idiom_translations sit
        JOIN translations st on sit.translation_id = st.id
        WHERE st.form SIMILAR TO :filter
        OR st.pronunciation SIMILAR TO :filter
      )
    SQL

    Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).where(where, :filter => filter_string).limit(50)
  end
end