include TranslationHelper
include IdiomHelper

class TranslationsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    idiom_translations = IdiomTranslation.where(:idiom_id => params[:term_id])

    if idiom_translations.count <= 2
      error_redirect_to t('notice.translation-delete-not-allowed'), :back
    else
      IdiomTranslation.where(:idiom_id => params[:term_id], :translation_id => params[:id]).each do |it|
        it.delete
      end

      RelatedTranslations::delete_relationships_for_transation Translation.find(params[:id])

      Translation.where(:id => params[:id]).each do |t|
        t.delete
      end

      success_redirect_to t('notice.translation-delete'), :back
    end
  end

  def attach
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:term_id]
    return error_redirect_to t('notice.not-found'), terms_path unless translation_exists? params[:id]

    if IdiomTranslation.where(:idiom_id => params[:term_id], :translation_id => params[:id]).empty?
      IdiomTranslation.create(:idiom_id => params[:term_id], :translation_id => params[:id])
    end
    RelatedTranslations::rebuild_relationships_for_translation Translation.find(params[:id])

    success_redirect_to t('notice.translation-attached'), term_path(params[:term_id])
  end
  
  def attach_and_detach
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:term_id]
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:remove_from_idiom_id]
    return error_redirect_to t('notice.not-found'), terms_path unless translation_exists? params[:id]

    IdiomTranslation.where(:idiom_id => params[:remove_from_idiom_id], :translation_id => params[:id]).each do |link|
      link.delete
    end
    if IdiomTranslation.where(:idiom_id => params[:term_id], :translation_id => params[:id]).empty?
      IdiomTranslation.create(:idiom_id => params[:term_id], :translation_id => params[:id])
    end

    RelatedTranslations::rebuild_relationships_for_translation Translation.find(params[:id])

    success_redirect_to t('notice.translation-moved'), term_path(params[:term_id])
  end

  def select
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? params[:term_id]
    
    @translations = Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).where(['idiom_translations.idiom_id != ?', params[:term_id]])
  end
end
