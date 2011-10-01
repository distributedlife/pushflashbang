module SetHelper
  def set_exists? id
    Sets::exists? id
  end

  def set_name_exists? set_id, set_name_id
    SetName::exists? set_id, set_name_id
  end

  def add_term_to_set set_id, term_id
    Sets.find(set_id).add_term term_id
  end

  def set_has_at_least_one_idiom_for_language? language_id, set_id
    Sets.find(set_id).has_at_least_one_idiom_for_language language_id
  end

  def is_user_at_end_of_chapter? user_id, set_id, language_id, review_mode
    unless language_is_valid? language_id
      error t('notice.not-found')
      return languages_path
    end
    unless set_exists? set_id
      error t('notice.not-found')
      return language_path(language_id)
    end

    review_types = parse_review_types review_mode
    if review_types.empty?
      error t('notice.review-mode-not-set')
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
      error t('notice.set-no-language-support')
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