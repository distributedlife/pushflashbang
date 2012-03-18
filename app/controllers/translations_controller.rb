# -*- encoding : utf-8 -*-
include TranslationHelper

class TranslationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :idiom_exists?
  before_filter :translation_exists?


  def idiom_exists?
    return error_redirect_to t('notice.not-found'), terms_path unless Idiom.exists? params[:term_id]
  end

  def translation_exists?
    return error_redirect_to t('notice.not-found'), terms_path unless Translation.exists? params[:id]
  end


  
  def destroy
    translation = Translation.find(params[:id])

    RelatedTranslations::delete_relationships_for_translation translation
    translation.delete

    success_redirect_to t('notice.translation-delete'), :back
  end

  def attach
    attach_to_idiom_id = params[:term_id]
    translation_id = params[:id]
    
    if Translation.where(:idiom_id => attach_to_idiom_id, :id => translation_id).empty?
      new_translation = Translation.find(translation_id).dup
      new_translation.idiom_id = attach_to_idiom_id
      new_translation.save!

      RelatedTranslations::rebuild_relationships_for_translation Translation.find(new_translation.id)
    end

    success_redirect_to t('notice.translation-attached'), term_path(attach_to_idiom_id)
  end
  
  def attach_and_detach
    attach_to_idiom_id = params[:term_id]
    detatch_from_idiom_id = params[:remove_from_idiom_id]
    translation_id = params[:id]

    return error_redirect_to t('notice.not-found'), terms_path unless Idiom.exists? detatch_from_idiom_id


    Translation.where(:idiom_id => detatch_from_idiom_id, :id => translation_id).each do |translation|
      translation.idiom_id = attach_to_idiom_id
      translation.save!
    end

    RelatedTranslations::rebuild_relationships_for_translation Translation.find(translation_id)

    success_redirect_to t('notice.translation-moved'), term_path(attach_to_idiom_id)
  end
end
