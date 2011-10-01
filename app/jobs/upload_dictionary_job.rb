include ArrayHelper

class UploadDictionaryJob
  @language
  @letter
  @skip

  def initialize language, letter, skip = false
    @language = language
    @letter = letter
    @skip = skip
  end

  def merge_idioms idioms = []
    return if idioms.empty?
    root = idioms.first
    idioms.each do |idiom|
      next if root == idiom

      Translation.where(:idiom_id => idiom.id).each do |it|
        it.idiom_id = root
        it.save!
      end

      #migrate reviews
      UserIdiomReviews.where(:idiom_id => idiom.id).each do |it|
        it.idiom_id = root
        it.save!
      end

      #migrate and merge schedule :TODO
#      UserIdiomSchedule.where(:idiom_id => idiom.id).each do |it|
#        it.idiom_id = root
#        it.save!
#      end

#      Idiom.delete(idiom)
    end

    root
  end

  def create_and_attach_translation_to_idiom form, language_id, idiom_id
    translation = Translation.create(:idiom_id => idiom_id, :form =>form, :language_id => language_id, :pronunciation => "")

    translation
  end

  def get_shared_idiom t1, t2
    Translation.where(:id => t1.id).each do |t1it|
      Translation.where(:id => t2.id).each do |t2it|
        next if t1it.id == t2it.id
        
        if t1it.idiom_id == t2it.idiom_id
          return Idiom.find(t1it.idiom_id)
        end
      end
    end

    return nil
  end

  def new_idiom type
    puts "NEW idiom"
    Idiom.create(:type => type)
  end

  def upload_dictionary full_set, language_name
    full_set.each do |potential_idiom|
      english = Language.get_or_create "English"
      definition = Language.get_or_create "Definition (English)"
      language = Language.get_or_create language_name


      #check for existence (due to failed imports)
      existing_definition = get_first(Translation.where(:form => potential_idiom[:definition], :language_id => definition.id)) unless potential_idiom[:definition].nil?
      existing_english = get_first(Translation.where(:form => potential_idiom[:english][:form], :language_id => english.id)) unless potential_idiom[:english][:form].nil?

#      puts "uploading... #{potential_idiom[:english][:form]}" unless potential_idiom[:english][:form].nil?

      #create idiom
      unless potential_idiom[:share_meaning].nil?
        #we may have to merge some idioms
        idioms_to_merge = []
        potential_idiom[:share_meaning].each do |containing_form|
          related_idiom = Idiom.get_idiom_containing_form containing_form

          idioms_to_merge << related_idiom unless related_idiom.nil?
        end

        idiom = merge_idioms(idioms_to_merge) unless idioms_to_merge.empty?
#        puts "reusing merged idiom" unless idiom.nil?
      end
      if !existing_definition.nil? and !existing_english.nil?
        idiom ||= get_shared_idiom existing_definition, existing_english
#        puts "reusing idiom" unless idiom.nil?
      end


      #english, create if one does not already exist
      if existing_english.nil?
        idiom ||= new_idiom potential_idiom[:english][:type] unless potential_idiom[:english][:form].nil?

        puts "NEW english translation for #{potential_idiom[:english][:form]}" unless potential_idiom[:english][:form].nil?
        create_and_attach_translation_to_idiom(potential_idiom[:english][:form], english.id, idiom.id) unless potential_idiom[:english][:form].nil?
      end


      #definintion, create if one does not already exist
      if existing_definition.nil?
        idiom ||= new_idiom potential_idiom[:english][:type] unless potential_idiom[:definition].nil?

        puts "NEW definition translation for #{potential_idiom[:definition]}" unless potential_idiom[:definition].nil?
        create_and_attach_translation_to_idiom(potential_idiom[:definition], definition.id, idiom.id) unless potential_idiom[:definition].nil?
      end


      #other languages
      unless potential_idiom[language_name.downcase.to_sym].nil?
        potential_idiom[language_name.downcase.to_sym][:definitions].each do |other_language|
          other_language[:form].each do |form|
            next if form.empty?

            if other_language[:notes].empty?
              translation = get_first(Translation.where(:form => form, :language_id => language.id, :t_type => other_language[:type].join(',')))
#              puts "reusing existing translation for #{form}" unless translation.nil?
              puts "NEW base translation for #{form}" if translation.nil?
              translation ||= Translation.create(:form => form, :t_type => other_language[:type].join(','), :language_id => language.id, :pronunciation => "")

              
              idiom ||= get_shared_idiom translation, existing_english if existing_definition.nil?
              idiom ||= get_shared_idiom translation, existing_definition if existing_english.nil?
              idiom ||= new_idiom potential_idiom[:english][:type]
              if Translation.where(:idiom_id => idiom.id, :id => translation.id).empty?
                Translation.create(:idiom_id => idiom.id, :id => translation.id)
              end
            else
              other_language[:notes].each do |region|
                regional = Language.get_or_create "#{language_name} (#{region})"

                translation = get_first(Translation.where(:form => form, :language_id => regional.id, :t_type => other_language[:type].join(',')))
#                puts "reusing existing translation for #{form}" unless translation.nil?
                puts "NEW regional translation for #{form} in #{region}" if translation.nil?
                translation ||= Translation.create(:form => form, :t_type => other_language[:type].join(','), :language_id => regional.id, :pronunciation => "")

                idiom ||= get_shared_idiom translation, existing_english if existing_definition.nil?
                idiom ||= get_shared_idiom translation, existing_definition if existing_english.nil?
                idiom ||= new_idiom potential_idiom[:english][:type]
                if Translation.where(:idiom_id => idiom.id, :id => translation.id).empty?
                  Translation.create(:idiom_id => idiom.id, :id => translation.id)
                end
              end
            end
          end
        end
      end
    end
  end

  def perform
    start = Time.now

    parser = BuchmeierDictionaryParser.new
    parser.parse @language, @letter

    upload_dictionary parser.results, @language

    finish = Time.now
    puts "*" * 80
    puts "Completed import."
    puts "Started at #{start} and finished at #{finish} (#{finish-start} seconds) for #{parser.results.count} records."
  end

  def check
    start = Time.now

    parser = BuchmeierDictionaryParser.new
    parser.parse @language, @letter

    notes = []
    parser.results.each do |result|
      next if result[:spanish].nil?
      next if result[:spanish][:definitions].empty?

      result[:spanish][:definitions].each do |d|
        next if d[:notes].empty?

        d[:notes].each do |note|
          unless notes & [note] == [note]
            notes << note
          end
        end
      end
    end

    finish = Time.now
    puts "*" * 80
    puts "Completed import."
    puts "Started at #{start} and finished at #{finish} (#{finish-start} seconds) for #{parser.results.count} records."
  end
end