include LanguagesHelper

class LanguagesController < ApplicationController
  before_filter :authenticate_user!

  caches_page :index, :show

  def index
    @languages = Language.order(:name).all
  end

  def user_languages
    @user_languages = UserLanguages.order(:name).joins(:language).where(:user_id => current_user.id)
  end

  def remaining_languages
    user_languages = UserLanguages.order(:name).joins(:language).where(:user_id => current_user.id)
    user_languages = user_languages.map{|l| l.language_id}

    if user_languages.empty?
      @languages = Language.order(:name).all
    else
      @languages = Language.order(:name).find(:all, :conditions => ["id NOT IN (?)", user_languages])
    end
  end

  def learn
    if language_is_valid_for_user? params[:id], current_user.id
      UserLanguages.create(:user_id => current_user.id, :language_id => params[:id])

      success t('notice.start-learn-language')
    end

    redirect_to user_languages_path
  end

  def unlearn
    if language_is_valid? params[:id]
      UserLanguages.where(:user_id => current_user.id, :language_id => params[:id]).each do |language|
        language.delete
      end

      success t('notice.stop-learn-language')
    end

    redirect_to user_languages_path
  end

  def show
    redirect_to user_index_path and return unless language_is_valid? params[:id]

    @language = Language.find(params[:id])
  end

  def select
    set_id = params[:set_id]
    @languages = []
    languages = []
    SetTerms.where(:set_id => set_id).each do |set_terms|
      IdiomTranslation.joins(:translation).where(:idiom_id => set_terms.term_id).each do |idiom_translation|

        language = get_first Language.where(:id => idiom_translation.translation.language_id)
        next if language.nil?
        next if language.id == current_user.native_language_id

        if languages[language.id].nil?
          languages[language.id] = language.id
            
          if UserSets.where(:set_id => set_id, :user_id => current_user.id, :language_id => language.id).empty?
            @languages << language
          end
        end
      end
    end

    @set_id = set_id
  end
end
