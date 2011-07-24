module IdiomComponent
  def create_idiom
    verify_idiom_prerequisites

    idiom = Idiom.make
    add(:idiom, idiom)

    idiom
  end

  def ensure_idiom_exists
    if does_not_exist(:idiom)
      add(:idiom, Idiom.make)
    end
  end

  def get_idiom_containing_form form
    idiom_translation = get_translation_group_using_form form

    raise "no translation exists using form" if idiom_translation.empty?

    Idiom.find(idiom_translation.first.idiom_id)
  end

  private
  def verify_idiom_prerequisites
    ensure_user_exists_and_is_logged_in
  end
end