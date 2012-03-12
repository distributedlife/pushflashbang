# -*- encoding : utf-8 -*-
class RebuildAllRelationshipsJob
  def perform
    start = Time.now

    RelatedTranslations::rebuild_all_relationships

    finish = Time.now
    puts "*" * 80
    puts "Started RebuildAllRelationshipsJob at #{start} and finished at #{finish} (#{finish-start} seconds)."
    puts "*" * 80
  end
end
