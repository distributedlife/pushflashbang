module TranslationComponent
  def create_translation hash
    verify_translation_prerequisites

    if hash.nil?
      hash = {}
      language = create_language nil
      hash[:language_id] = language.id
    else
      language = get_language hash[:language]
      hash = swap_language_for_id hash, language.id
    end

    translation = Translation.make hash
    idiom_translation = IdiomTranslation.make(:idiom_id => get(:idiom).id, :translation_id => translation.id)

    add(:translation, translation)
    add(:idiom_translation, idiom_translation)
  end

  def create_translation_attached_to_idiom idiom, hash
    verify_translation_prerequisites

    language = get_language hash[:language]
    hash = swap_language_for_id hash, language.id

    translation = Translation.make hash
    idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation.id)

    add(:translation, translation)
    add(:idiom_translation, idiom_translation)
  end

  def get_translation_using_form form
    return Translation.where(:form => form)
  end

  def get_translation_group_using_form form
    return IdiomTranslation.joins(:translation).where(:translations => {:form => form})
  end

  def get_translation_group_using_idiom idiom
    return IdiomTranslation.joins(:translation).where(:idiom_id => idiom.id)
  end

  private
  def verify_translation_prerequisites
    ensure_user_exists_and_is_logged_in
    ensure_idiom_exists
  end
end