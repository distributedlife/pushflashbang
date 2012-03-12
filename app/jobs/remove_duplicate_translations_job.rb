# -*- encoding : utf-8 -*-
class RemoveDuplicateTranslationsJob
  def perform
    start = Time.now

    Translation::remove_duplicates

    finish = Time.now
    puts "*" * 80
    puts "Started RemoveDuplicateTranslationsJob at #{start} and finished at #{finish} (#{finish-start} seconds)."
    puts "*" * 80
  end
end
