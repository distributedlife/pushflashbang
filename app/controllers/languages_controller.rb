class LanguagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @languages = Language.all
    @user_languages = UserLanguages.joins(:language).where(:user_id => current_user.id)
  end

  def learn
    if language_is_valid_for_user?
      UserLanguages.create(:user_id => current_user.id, :language_id => params[:id])
    end

    redirect_to languages_path
  end

  def unlearn
    if language_is_valid?
      UserLanguages.where(:user_id => current_user.id, :language_id => params[:id]).each do |language|
        language.delete
      end
    end

    redirect_to languages_path
  end

  private
  def language_is_valid?
    begin
      Language.find(params[:id]) == false
    rescue
      return false
    end

    return true
  end

  def language_is_valid_for_user?
    return false if UserLanguages.where(:user_id => current_user.id, :language_id => params[:id]).count == 1

    begin
      Language.find(params[:id]) == false
    rescue
      return false
    end

    return true
  end
end
