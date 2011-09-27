include ArrayHelper

class Idiom < ActiveRecord::Base
  has_many :idiom_translation
  has_many :translations

  attr_accessible :idiom_type

  def self.translations_in_idiom_and_language idiom_id, language_id
    Translation.joins(:languages).order(:form).where(:language_id => language_id, :idiom_id => idiom_id)
  end

  def self.get_idiom_containing_form form
    translation = get_first Translation.where(:form => form)

    return nil if translation.nil?

    Idiom.find(translation.idiom_id)
  end
end