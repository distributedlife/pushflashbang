class Translation < ActiveRecord::Base
  belongs_to :languages, :class_name => "Language", :foreign_key => "language_id"
  belongs_to :idiom_translations, :class_name => "IdiomTranslation", :foreign_key => "id", :primary_key => "translation_id"
  
  has_paper_trail

  attr_accessible :language_id, :form, :pronunciation

  validates :language_id, :presence => true
  validates :form, :presence => true
end