module UserComponent
  def create_user
    english = ensure_language_exists "English"
    
    add(:user, User.make!(:native_language_id => english.id))
  end

  def log_in_user
    And %{I login with "#{get(:user).email}" and "#{get(:user).password}"}
  end

  def ensure_user_exists_and_is_logged_in
    return get(:user) unless does_not_exist(:user)

    create_user
    log_in_user

    get(:user)
  end
end