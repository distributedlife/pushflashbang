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
    relate_translation_to_others translation.id, get(:idiom).id

    add(:translation, translation)
    add(:idiom_translation, idiom_translation)
  end

  def create_translation_attached_to_idiom idiom, hash
    verify_translation_prerequisites

    language = get_language hash[:language]
    hash = swap_language_for_id hash, language.id

    translation = Translation.make hash
    idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation.id)
    relate_translation_to_others translation.id, idiom.id

    add(:translation, translation)
    add(:idiom_translation, idiom_translation)
  end

  def relate_translation_to_others translation_id, idiom_id
    t = Translation.find translation_id

    Translation.all.each do |other|
      next if other.id == t.id

      relate_translations t, other
    end

    IdiomTranslation.where(:idiom_id => idiom_id).each do |other|
      next if other.translation_id == t.id

      relate_translations_by_meaning t, other
    end
  end

  def relate_translations_by_meaning t1, t2
    rt1 = RelatedTranslations.where(:translation1_id => t1.id, :translation2_id => t2.id)
    rt2 = RelatedTranslations.where(:translation1_id => t2.id, :translation2_id => t1.id)

    if rt1.empty?
      rt1 = RelatedTranslations.new(:translation1_id => t1.id, :translation2_id => t2.id)
      rt1.share_meaning = true
      rt1.save!
    else
      rt1 = rt1.first
      rt1.share_meaning = true
      rt1.save!
    end
    if rt2.empty?
      rt2 = RelatedTranslations.new(:translation1_id => t2.id, :translation2_id => t1.id)
      rt2.share_meaning = true
      rt2.save!
    else
      rt2 = rt2.first
      rt2.share_meaning = true
      rt2.save!
    end
  end

  def relate_translations t1, t2
    rt1 = RelatedTranslations.new(:translation1_id => t1.id, :translation2_id => t2.id)
    rt2 = RelatedTranslations.new(:translation1_id => t2.id, :translation2_id => t1.id)
    if t1.language_id == t2.language_id
      if t1.form == t2.form
        rt1.share_written_form = true
        rt2.share_written_form = true
      end
      if t1.pronunciation == t2.pronunciation and !t1.pronunciation.empty? and !t2.pronunciation.empty?
        rt1.share_audible_form = true
        rt2.share_audible_form = true
      end
    end

    return if rt1.share_meaning.nil? and rt1.share_written_form.nil? and rt1.share_audible_form.nil?
    return if rt2.share_meaning.nil? and rt2.share_written_form.nil? and rt2.share_audible_form.nil?

    rt1.share_meaning ||= false
    rt1.share_written_form ||= false
    rt1.share_audible_form ||= false
    rt2.share_meaning ||= false
    rt2.share_written_form ||= false
    rt2.share_audible_form ||= false

    rt1.save!
    rt2.save!
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

  def related_translations_are_the_same t1_id, t2_id
    rt1 = RelatedTranslations.where(:translation1_id => t1_id, :translation2_id => t2_id)
    rt2 = RelatedTranslations.where(:translation1_id => t2_id, :translation2_id => t1_id)
    rt1.count.should == 1
    rt2.count.should == 1

    rt1.first.share_meaning.should == rt2.first.share_meaning
    rt1.first.share_audible_form.should == rt2.first.share_audible_form
    rt1.first.share_written_form.should == rt2.first.share_written_form
  end

  def translations_are_not_related t1_id, t2_id
    rt1 = RelatedTranslations.where(:translation1_id => t1_id, :translation2_id => t2_id)
    rt2 = RelatedTranslations.where(:translation1_id => t2_id, :translation2_id => t1_id)
    rt1.count.should == 0
    rt2.count.should == 0
  end

  def translations_are_related_by_meaning? t1_id, t2_id
    RelatedTranslations.where(:translation1_id => t1_id, :translation2_id => t2_id).first.share_meaning
  end

  def translations_are_related_by_written_form? t1_id, t2_id
    RelatedTranslations.where(:translation1_id => t1_id, :translation2_id => t2_id).first.share_written_form
  end

  def translations_are_related_by_audible_form? t1_id, t2_id
    RelatedTranslations.where(:translation1_id => t1_id, :translation2_id => t2_id).first.share_audible_form
  end

  private
  def verify_translation_prerequisites
    ensure_user_exists_and_is_logged_in
    ensure_idiom_exists
  end
end