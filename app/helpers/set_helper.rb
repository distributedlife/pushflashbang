module SetHelper
  def set_exists? id
    begin
      Sets.find(id)

      true
    rescue
      false
    end
  end

  def set_name_exists? set_id, set_name_id
    begin
      # set name exists
      set_name = SetName.find(set_name_id)

      # and set name belongs to set
      return set_name.sets_id == set_id.to_i
    rescue
      false
    end
  end

  def add_term_to_set set_id, term_id
    if SetTerms.where(:set_id => set_id, :term_id => term_id).empty?
      max_position = SetTerms.where(:set_id => set_id).maximum(:position)
      max_position ||= 0
      max_chapter = SetTerms.where(:set_id => set_id).maximum(:chapter)
      max_chapter ||= 1

      SetTerms.create(:set_id => set_id, :term_id => term_id, :chapter => max_chapter, :position => max_position + 1)
    end
  end

  def set_has_at_least_one_idiom_for_language? language_id, set_id
    language_id = language_id.to_i
    set_id = set_id.to_i

    SetTerms.where(:set_id => set_id).each do |set_terms|
      IdiomTranslation.joins(:translation).where(:idiom_id => set_terms.term_id).each do |idiom_translation|
        begin
          language = Language.find(idiom_translation.translation.language_id)
        rescue
          next
        end

        if language.id == language_id
          return true
        end
      end
    end

    false
  end

  def is_user_at_end_of_chapter user_id, set_id, language_id, review_mode
    return languages_path unless language_is_valid? language_id
    return language_path(language_id) unless set_exists? set_id

    review_types = parse_review_types review_mode
    if review_types.empty?
      return language_set_path(language_id, set_id)
    end

    #get user set
    user_set = UserSets.where(:user_id => user_id, :set_id => set_id, :language_id => language_id)
    if user_set.empty?
      return language_sets_path(language_id, set_id)
    end
    user_set = user_set.first


    #are there cards in the set for the language?
    unless set_has_at_least_one_idiom_for_language? language_id, set_id
      flash[:failure] = "This set can't be reviewed in the specified language because it has not been translated into that language"
      return language_set_path(language_id, set_id)
    end


    #are there are any due cards?
    next_due = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies language_id, user_id, set_id, review_types
    unless next_due.nil?
      return review_language_set_path(language_id, set_id, :review_mode => review_mode)
    end


    #there are no due cards; can we schedule one?
    next_term = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies(language_id, current_user.native_language_id, user_id, set_id, review_types)
    #there are no cards left at all; we should go to the completed page
    if next_term.nil?
      return review_language_set_path(language_id, set_id, :review_mode => review_mode)
    end

    #redirect if we have to schedule in this chapter
    unless next_term.chapter > user_set.chapter
      return review_language_set_path(language_id, set_id, :review_mode => review_mode)
    end

    return nil
  end
end