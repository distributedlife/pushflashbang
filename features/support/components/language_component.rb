module LanguageComponent
  def add_language_to_user language_name
    user = ensure_user_exists_and_is_logged_in
    language = ensure_language_exists language_name

    UserLanguages.make(:language_id => language.id, :user_id => user.id)
  end

  def ensure_language_exists language_name
    matches = Language.where(:name => language_name)

    if matches.empty?
      Language.make(:name => language_name)
    else
      matches.first
    end
  end

  def get_language language_name
    matches = Language.where(:name => language_name)

    return matches.first
  end

  def user_is_learning_language? language_name
    language = ensure_language_exists language_name

    UserLanguages.where(:language_id => language.id, :user_id => get(:user).id).count == 1
  end
end