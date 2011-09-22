module TranslationHelper
  def all_translations_sorted_correctly
    Translation.all_sorted_by_idiom_language_and_form
  end

  def all_translations_sorted_correctly_with_like_filter filter
    Translation.all_sorted_by_idiom_language_and_form_with_like_filter filter
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