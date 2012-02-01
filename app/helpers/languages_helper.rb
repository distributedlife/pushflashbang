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

  def user_is_learning_language? language_id, user_id
    return UserLanguages.where(:user_id => user_id, :language_id => language_id).count > 0
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

  def merge_languages language_id, language_to_merge_id
    source = Language.find language_id
    merged_language = Language.find language_to_merge_id

    return if source.nil? or merged_language.nil?

    User.where(:native_language_id => language_to_merge_id).each {|u| u.native_language_id = language_id; u.save!}
    UserLanguages.where(:language_id => language_to_merge_id).each {|ul| ul.language_id = language_id; ul.save!}
    UserSets.where(:language_id => language_to_merge_id).each {|us| us.language_id = language_id; us.save!}
    Translation.where(:language_id => language_to_merge_id).each {|t| t.language_id = language_id; t.save!}
    UserIdiomSchedule.where(:language_id => language_to_merge_id).each {|uis| uis.language_id = language_id; uis.save!}
    UserIdiomReview.where(:language_id => language_to_merge_id).each {|uir| uir.language_id = language_id; uir.save!}


    merged_language.disable!
  end
end
