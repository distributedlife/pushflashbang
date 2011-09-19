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

  def search
    # pull out languages - use as filter
    # pull out types - use as filter
    # the remainder is the query
  end
end