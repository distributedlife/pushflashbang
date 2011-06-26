module IdiomComponent
  def create_idiom
    verify_idiom_prerequisites

    Idiom.create
  end

  def ensure_idiom_exists
    if does_not_exist(:idiom)
      add(:idiom, Idiom.create)
    end
  end

  def get_idiom_containing_form form
    translation = get_translation_using_form form

    raise "no translation exists using form" if translation.empty?

    Idiom.find(translation.first.idiom_id)
  end

  private
  def verify_idiom_prerequisites
    ensure_user_exists_and_is_logged_in
  end
end