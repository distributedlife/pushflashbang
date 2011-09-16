class Idiom < ActiveRecord::Base
  has_many :idiom_translation
  has_many :translations, :through => :idiom_translation

  attr_accessible :idiom_type

  def self.translations_in_idiom_and_language idiom_id, language_id
    Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => language_id, :idiom_translations => {:idiom_id => idiom_id})
  end

  def self.get_idiom_containing_form form
    idiom_translation = IdiomTranslation.joins(:translation).where(:translations => {:form => form})

    return nil if idiom_translation.empty?

    Idiom.find(idiom_translation.first.idiom_id)
  end
end