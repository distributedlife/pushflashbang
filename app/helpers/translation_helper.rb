module TranslationHelper
  def all_translations_sorted_correctly
    Translation.all_sorted_by_idiom_language_and_form
  end

  def all_translations_sorted_correctly_with_like_filter filter, limit, offset
    Translation.all_sorted_by_idiom_language_and_form_with_like_filter filter, limit, offset
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