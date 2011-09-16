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
    RelatedTranslations::create_relationships_for_translation translation
  end

  def self.create_relationships_for_translation translation
    candidates = <<-SQL
      SELECT * 
      FROM translations 
      WHERE form = '#{translation.form.gsub("'", "\'")}'
      OR language_id = #{translation.language_id}
      OR pronunciation = '#{translation.pronunciation.gsub("'", "\'")}'
    SQL
    Translation.find_by_sql(candidates).each do |t2|
      next if translation.id == t2.id

      RelatedTranslations::create_relationship_if_needed translation, t2
    end
  end

  def self.create_relationship_if_needed t1, t2
    rt1 = get_relationship t1.id, t2.id
    rt2 = get_relationship t2.id, t1.id

    rt1 ||= RelatedTranslations.new(:translation1_id => t1.id, :translation2_id => t2.id)
    rt2 ||= RelatedTranslations.new(:translation1_id => t2.id, :translation2_id => t1.id)

    if t1.language_id == t2.language_id
      if IdiomTranslation.translations_share_idiom? t1.id, t2.id
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

  def self.get_related translation_ids, user_id, language_id, options = {}
    options[:meaning] = 'true,false' if options[:meaning].nil?
    options[:written] = 'true,false' if options[:written].nil?
    options[:audible] = 'true,false' if options[:audible].nil?

    get_related_sql = <<-SQL
      SELECT distinct(rt.translation2_id)
      FROM related_translations rt
      JOIN idiom_translations it ON rt.translation2_id = it.translation_id
      JOIN user_idiom_schedules uis ON it.idiom_id = uis.idiom_id AND uis.user_id = #{user_id} AND uis.language_id = #{language_id}
      WHERE rt.translation1_id IN (#{translation_ids.join(',')})
        AND rt.share_meaning IN (#{options[:meaning]})
        AND rt.share_written_form IN (#{options[:written]})
        AND rt.share_audible_form IN (#{options[:audible]})
    SQL

    related = self.find_by_sql(get_related_sql)
    related = related.map{|s| s.translation2_id}
    related | translation_ids
  end
end
