#require '/app/scripts/buchmeier_dictionary_parser.rb'

def merge_idioms idioms = []
	return if idioms.empty?
ap idioms
	root = idioms.first
	idioms.each do |idiom|
		next if root == idiom

		IdiomTranslations.where(:idiom_id => idiom.id).each do |it|
			it.idiom_id = root
			it.save!
		end
  end

  #relate translations in root idiom (as they may now share meaning)
	IdiomTranslation.where(:idiom_id => root.id).each do |it1|
    IdiomTranslation.where(:idiom_id => root.id).each do |it2|
      next if it1.translation_id == it2.translation_id

      RelatedTranslations.create_relationship_if_needed Translation.find(it1), Translation.find(it2)
    end
	end

	root
end

def create_and_attach_translation_to_idiom form, language_id, idiom_id
  translation = Translation.create(:form =>form, :language_id => language_id, :pronunciation => "")
  IdiomTranslation.create(:idiom_id => idiom_id, :translation_id => translation.id)

  translation
end

def upload_dictionary full_set, language_name
  full_set.each do |potential_idiom|
    english = Language.get_or_create "English"
    definition = Language.get_or_create "Definition (English)"
    language = Language.get_or_create language_name


    #create idiom
    unless potential_idiom[:share_meaning].nil?
      #we may have to merge some idioms
      idioms_to_merge = []
      potential_idiom[:share_meaning].each do |containing_form|
        related_idiom = Idiom.get_idiom_containing_form containing_form

        idioms_to_merge << related_idiom unless related_idiom.nil?
      end

      idiom = merge_idioms(idioms_to_merge) unless idioms_to_merge.empty?
    end
    idiom ||= Idiom.create(:type => potential_idiom[:english][:type])

    #english
    english_translation = create_and_attach_translation_to_idiom(potential_idiom[:english][:form], english.id, idiom.id) unless potential_idiom[:english][:form].nil?


    #definintion
    definition_translation = create_and_attach_translation_to_idiom(potential_idiom[:definition], definition.id, idiom.id) unless potential_idiom[:definition].nil?


    #other languages
    other_translations = []
    ap potential_idiom
    unless potential_idiom[language_name.downcase.to_sym].nil?
      potential_idiom[language_name.downcase.to_sym][:definitions].each do |other_language|
        other_language[:form].each do |form|
          next if form.empty?
          
          translation = Translation.new(:form => form, :type => other_language[:type].join(','), :pronunciation => "")
          if other_language[:notes].empty?
            translation.language_id = language.id
            translation.save!
            IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation.id)
          else
            other_language[:notes].each do |region|
              regional = Language.get_or_create "#{language_name} (#{region})"

              translation.language_id = regional.id
              translation.save!
              IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation.id)
            end
          end

          other_translations << translation
        end
      end
    end

    #related translations
    RelatedTranslations.create_relationships_for_translation(english_translation) unless english_translation.nil?
    RelatedTranslations.create_relationships_for_translation(definition_translation) unless definition_translation.nil?
    other_translations.each do |t|
      RelatedTranslations.create_relationships_for_translation t
    end
  end
end


parser = BuchmeierDictionaryParser.new
parser.parse "spanish"

#ap full_set
start = Time.now
upload_dictionary parser.results, "Spanish"
finish = Time.now

puts "*" * 80
puts "Completed import."
puts "Started at #{start} and finished at #{finish} (#{finish-start} seconds) for #{parser.results.count} records."