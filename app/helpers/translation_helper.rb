module TranslationHelper
  def all_translations_sorted_correctly
    Translation.joins(:languages).order("idiom_id asc").order("name asc").order("form asc").all
  end

  def all_translations_sorted_correctly_for_idiom idiom_id
    Translation.joins(:languages).order("name asc").order("form asc").where(:idiom_id => idiom_id)
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