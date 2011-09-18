class CreateRelationshipsJob
  def perform
    start = Time.now

    count = find_translations_with_no_relationships

    finish = Time.now
    puts "*" * 80
    puts "Started CreateRelationshipsJob at #{start} and finished at #{finish} (#{finish-start} seconds) for #{count} records"
    puts "*" * 80
  end

  def find_translations_with_no_relationships
    sql = <<-SQL
      SELECT id
      FROM translations
      EXCEPT
      SELECT translation1_id
      FROM related_translations
    SQL

    translations = Translation.find_by_sql(sql)
    translations.each_with_index do |t, index|
      puts "processing #{index}/#{translations.count}"
      RelatedTranslations::create_relationships_for_translation Translation.find(t)
    end

    translations.count
  end
end