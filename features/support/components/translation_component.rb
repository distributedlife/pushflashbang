module TranslationComponent
  def create_translation hash
    verify_translation_prerequisites

    translation = Translation.create hash
    translation.idiom_id = get(:idiom).id
    translation.save!

    add(:translation, translation)
  end

  def create_translation_attached_to_idiom idiom, hash
    verify_translation_prerequisites

    translation = Translation.new hash
    translation.idiom_id = idiom.id
    translation.save!

    add(:translation, translation)
  end

  def get_translation_using_form form
    return Translation.where(:form => form)
  end

  def get_translations_using_idiom idiom
    return Translation.where(:idiom_id => idiom.id)
  end

  private
  def verify_translation_prerequisites
    ensure_user_exists_and_is_logged_in
    ensure_idiom_exists
  end
end