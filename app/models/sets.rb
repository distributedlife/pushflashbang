class Sets < ActiveRecord::Base
  has_many :set_name
  has_many :set_terms, :class_name => "SetTerms", :foreign_key => "set_id"

  def delete
    SetName.where(:sets_id => self.id).each do |set_name|
      set_name.delete
    end

    return super
  end

  def migrate_from_deck deck_id
    deck = Deck.find deck_id
    chinese = Language.where(:name => "Chinese (Simplified)")
    if chinese.empty?
      chinese = Language.create(:name => "Chinese (Simplified)")
    else
      chinese = chinese.first
    end
    english = Language.where(:name => "English")
    if english.empty?
      english = Language.create(:name => "English")
    else
      english = english.first
    end

    index = 1
    current_chapter = 1
    Card.order(:id).where(:deck_id => deck.id).each do |card|
      if current_chapter != card.chapter
        index = 1
        current_chapter = current_chapter + 1
      end

      idiom = Idiom.create

      chinese_translation = Translation.create(:idiom_id => idiom.id, :language_id => chinese.id, :form => card.front, :pronunciation => card.pronunciation)
      IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => chinese_translation.id)

      card.back.split(',').each do |form|
        form.strip!

        english_translation = Translation.create(:idiom_id => idiom.id, :language_id => english.id, :form => form, :pronunciation => "")
        IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => english_translation.id)
      end

      SetTerms.create(:set_id => self.id, :term_id => idiom.id, :chapter => card.chapter, :position => index)
      index = index + 1
    end
  end
end
