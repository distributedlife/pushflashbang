module IdiomHelper
  def idiom_exists? idiom_id
    begin
      Idiom.find(idiom_id)

      true
    rescue
      false
    end
  end

  def get_idioms_from_translations translations
    idiom_translations = IdiomTranslation.find(:all, :conditions => ['translation_id in (?)', translations])
    idiom_translations = idiom_translations.map{|t| t.idiom_id}
    Idiom.find(idiom_translations)
  end

  def get_idiom_translations
    if idiom_exists? params[:id]
      @translations = Translation.joins(:languages, :idiom_translations).order(:name).order(:form).where(:idiom_translations => {:idiom_id => params[:id]})

      if @translations.empty?
        error_redirect_to t('notice.term-no-translations'), terms_path
      end
    else
      error_redirect_to t('notice.not-found'), terms_path
    end
  end
end
