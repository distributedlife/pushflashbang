module TranslationHelper
  def all_translations_sorted_correctly
    Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).all
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