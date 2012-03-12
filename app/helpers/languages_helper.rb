# -*- encoding : utf-8 -*-
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
      l = Language.find(language_id)

      return l.enabled?
    rescue
      return false
    end
  end

  def merge_languages language_id, language_to_merge_id
    source = Language.find language_id
    merged_language = Language.find language_to_merge_id

    return if source.nil? or merged_language.nil?

    User.where(:native_language_id => language_to_merge_id).each {|u| u.native_language_id = language_id; u.save!}
    UserLanguages.where(:language_id => language_to_merge_id).each {|ul| ul.language_id = language_id; ul.save!}
    UserSets.where(:language_id => language_to_merge_id).each {|us| us.language_id = language_id; us.save!}

    translations = Translation.where(:language_id => language_to_merge_id)
    translations.each do |t|
      t.language_id = language_id
      t.save!

      RelatedTranslations::rebuild_relationships_for_translation t
    end


    UserIdiomSchedule.where(:language_id => language_to_merge_id).each do |uis|
      if UserIdiomSchedule.where(:idiom_id => uis.idiom_id, :user_id => uis.user_id, :language_id => language_id).empty?
        uis.language_id = language_id
        uis.save!
      else
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis.id).each {|uidi| uidi.delete}
        uis.delete
      end
    end
    UserIdiomReview.where(:language_id => language_to_merge_id).each {|uir| uir.language_id = language_id; uir.save!}


    merged_language.disable!
  end
end
