class MoveToDenormalisedTranslations < ActiveRecord::Migration
  def self.up
    # add idiom to translation
    add_column :translations, :idiom_id, :integer

    # for each translation
    all_translations = Translation.all
    all_translations.each_with_index do |translation, translation_index|
      puts "#{translation_index}/#{all_translations.count}"
      
      idiom_translations = IdiomTranslation.where(:translation_id => translation.id)
      if idiom_translations.empty?
        puts "Translation #{translation.id} is an orphan"
        next
      end


      if idiom_translations.count == 1
        translation.idiom_id = idiom_translations.first.idiom_id
        translation.save!
        next
      end

      
      idiom_translations.each_with_index do |it, index|
        if index == 0
          translation.idiom_id = it.idiom_id
          translation.save!
          next
        end


        denormalised_translation = translation.clone
        denormalised_translation.idiom_id = it.idiom_id
        denormalised_translation.save!
      end
    end
  end

  def self.down
    remove_column :translations, :idiom_id, :integer
  end
end
