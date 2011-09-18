class RebuildAllRelationshipsJob
  def perform
    start = Time.now

    count = rebuild_all

    finish = Time.now
    puts "*" * 80
    puts "Started RebuildAllRelationshipsJob at #{start} and finished at #{finish} (#{finish-start} seconds) for #{count} records"
    puts "*" * 80
  end

  def rebuild_all
    translations = Translation.all
    translations.each do |t|
      RelatedTranslations::rebuild_relationships_for_translation t
    end

    translations.count
  end
end