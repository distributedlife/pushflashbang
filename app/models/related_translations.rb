class RelatedTranslations < ActiveRecord::Base
  attr_accessible :translation1_id, :translation2_id, :share_written_form, :share_audible_form, :share_meaning

  validates :translation1_id, :presence => true
  validates :translation2_id, :presence => true

  def self.get_relationship t1_id, t2_id
    rt = RelatedTranslations.where(:translation1_id => t1_id, :translation2_id => t2_id)

    if rt.empty?
      nil
    else
      rt.first
    end
  end
  
  def self.delete_relationships_for_transation translation
    RelatedTranslations.where(:translation1_id => translation.id).each do |rt|
      rt.delete
    end
    RelatedTranslations.where(:translation2_id => translation.id).each do |rt|
      rt.delete
    end
  end

  def self.rebuild_relationships_for_translation translation
    RelatedTranslations::delete_relationships_for_transation translation

    Translation.all.each do |t2|
      next if translation.id == t2.id

      RelatedTranslations::create_relationship_if_needed translation,t2
    end
  end

  def self.create_relationships_for_translation translation
    Translation.all.each do |t2|
      next if translation.id == t2.id

      RelatedTranslations::create_relationship_if_needed translation,t2
    end
  end

  def self.create_relationship_if_needed t1, t2
    rt1 = get_relationship t1.id, t2.id
    rt2 = get_relationship t2.id, t1.id

    rt1 ||= RelatedTranslations.new(:translation1_id => t1.id, :translation2_id => t2.id)
    rt2 ||= RelatedTranslations.new(:translation1_id => t2.id, :translation2_id => t1.id)

    if t1.language_id == t2.language_id
      if IdiomTranslation.translations_share_idiom t1.id, t2.id
        rt1.share_meaning = true
        rt2.share_meaning = true
      end
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
end
