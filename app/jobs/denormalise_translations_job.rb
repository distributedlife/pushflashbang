class DenormaliseTranslationsJob
  def perform
    start = Time.now

    Translation.find_each(:batch_size => 10000) do |translation|
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

    finish = Time.now
    puts "*" * 80
    puts "Started DenormaliseTranslationsJob at #{start} and finished at #{finish} (#{finish-start} seconds)."
    puts "*" * 80
  end
end