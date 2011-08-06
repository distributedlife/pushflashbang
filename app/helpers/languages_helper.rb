module LanguagesHelper
  def language_is_valid? language_id
    begin
      Language.find(language_id)
      true
    rescue
      return false
    end

    return true
  end

  def language_is_valid_for_user? language_id, user_id
    return false unless UserLanguages.where(:user_id => user_id, :language_id => language_id).empty?

    begin
      Language.find(language_id) == false
    rescue
      return false
    end

    return true
  end
end
