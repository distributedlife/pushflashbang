class TranslationsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    idiom_translations = IdiomTranslation.where(:idiom_id => params[:term_id])

    if idiom_translations.count <= 2
      flash[:failure] = "Can't delete a translation from a term that has only two translations"
    else
      IdiomTranslation.where(:idiom_id => params[:term_id], :translation_id => params[:id]).each do |it|
        it.delete
      end

      Translation.where(:id => params[:id]).each do |t|
        t.delete
      end
    end

    redirect_to :back
  end

  def attach
    return redirect_to terms_path unless idiom_exists? params[:term_id]
    return redirect_to terms_path unless translation_exists? params[:id]

    if IdiomTranslation.where(:idiom_id => params[:term_id], :translation_id => params[:id]).empty?
      IdiomTranslation.create(:idiom_id => params[:term_id], :translation_id => params[:id])
    end

    redirect_to term_path(params[:term_id])
  end
  
  def attach_and_detach
    return redirect_to terms_path unless idiom_exists? params[:term_id]
    return redirect_to terms_path unless idiom_exists? params[:remove_from_idiom_id]
    return redirect_to terms_path unless translation_exists? params[:id]

    IdiomTranslation.where(:idiom_id => params[:remove_from_idiom_id], :translation_id => params[:id]).each do |link|
      link.delete
    end
    if IdiomTranslation.where(:idiom_id => params[:term_id], :translation_id => params[:id]).empty?
      IdiomTranslation.create(:idiom_id => params[:term_id], :translation_id => params[:id])
    end

    redirect_to term_path(params[:term_id])
  end

  def select
    return redirect_to terms_path unless idiom_exists? params[:term_id]
    
    @translations = Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).where(['idiom_translations.idiom_id != ?', params[:term_id]])
  end

  private
  def idiom_exists? idiom_id
    begin
      Idiom.find(idiom_id)

      true
    rescue
      false
    end
  end

  def translation_exists? translation_id
    begin
      Translation.find(translation_id)

      true
    rescue
      false
    end
  end
end
