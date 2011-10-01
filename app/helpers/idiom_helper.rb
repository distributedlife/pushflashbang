module IdiomHelper
  def idiom_exists? idiom_id
    Idiom::exists? idiom_id
  end

  def get_idioms_from_translations translation_ids
    Idiom::get_from_translations translation_ids
  end
end
