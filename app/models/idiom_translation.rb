class IdiomTranslation < ActiveRecord::Base
  validates :idiom_id, :presence => true
  validates :translation_id, :presence => true

  belongs_to :idiom
  belongs_to :translation
end