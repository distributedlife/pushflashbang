include LanguagesHelper

class LanguagesController < ApplicationController
  before_filter :authenticate_user!

#  caches_page :index, :show

  def index
    @languages = Language.order(:name).all
    @user_languages = UserLanguages.order(:name).joins(:language).where(:user_id => current_user.id)
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
    @user_sets = []
    @sets = []
    set_ids = []

    IdiomTranslation.joins(:translation).where(:translations => {:language_id => @language.id}).each do |idiom_translation|
      SetTerms.where(:term_id => idiom_translation.idiom_id).each do |set_terms|
        if set_ids[set_terms.set_id].nil?
          set_ids[set_terms.set_id] = set_terms.set_id
          
          Sets.where(:id => set_terms.set_id).each do |set|
            if UserSets.where(:set_id => set.id, :user_id => current_user.id).empty?
              @sets << set
            else
              @user_sets << set
            end
          end
        end
      end
    end
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
