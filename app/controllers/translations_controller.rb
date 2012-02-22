include TranslationHelper
include IdiomHelper

class TranslationsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    translations_in_idiom = Translation.where(:idiom_id => params[:term_id])

    if translations_in_idiom.count <= 2
      error_redirect_to t('notice.translation-delete-not-allowed'), :back
    else
      RelatedTranslations::delete_relationships_for_translation Translation.find(params[:id])

      Translation.where(:id => params[:id]).each do |t|
        t.delete
      end

      success_redirect_to t('notice.translation-delete'), :back
    end
  end

  def attach
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:term_id]
    return error_redirect_to t('notice.not-found'), terms_path unless translation_exists? params[:id]

    idiom_id = params[:term_id]
    translation_id = params[:id]
    
    if Translation.where(:idiom_id => idiom_id, :id => translation_id).empty?
      new_translation = Translation.find(translation_id).dup
      new_translation.idiom_id = idiom_id
      new_translation.save!

      RelatedTranslations::rebuild_relationships_for_translation Translation.find(new_translation.id)
    end

    success_redirect_to t('notice.translation-attached'), term_path(params[:term_id])
  end
  
  def attach_and_detach
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:term_id]
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:remove_from_idiom_id]
    return error_redirect_to t('notice.not-found'), terms_path unless translation_exists? params[:id]

    Translation.where(:idiom_id => params[:remove_from_idiom_id], :id => params[:id]).each do |translation|
      translation.idiom_id = params[:term_id]
      translation.save!
    end

    RelatedTranslations::rebuild_relationships_for_translation Translation.find(params[:id])

    success_redirect_to t('notice.translation-moved'), term_path(params[:term_id])
  end

  def select
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:term_id]
    
    @translations = Translation.joins(:languages).order(:idiom_id).order(:name).order(:form).where(['idiom_id != ?', params[:term_id]])
  end
end
