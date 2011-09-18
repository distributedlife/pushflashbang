include ArrayHelper

class RebuildAllRelationshipsJob
  def perform
    start = Time.now

    RelatedTranslations.delete_all

    c1 = relate_all_that_share_form
    c2 = relate_all_that_share_pronunciation
    c3 = relate_all_that_share_meaning

    finish = Time.now
    puts "*" * 80
    puts "Started RebuildAllRelationshipsJob at #{start} and finished at #{finish} (#{finish-start} seconds) for #{c1 + c2 + c3} records"
    puts "*" * 80
  end

  def relate_all_that_share_form
    share_form_sql = <<-SQL
      SELECT form, language_id, count(*)
      FROM translations t1
      GROUP BY form, language_id
      HAVING count(*) > 1
    SQL

    share_form_results = ActiveRecord::Base.connection.execute(share_form_sql)
    share_form_results.each do |share_form|
      t1_set = Translation.where(:form => share_form["form"], :language_id => share_form["language_id"])
      t2_set = t1_set

      t1_set.each do |t1|
        t2_set.each do |t2|
          next if t1.id == t2.id

          rt = get_first RelatedTranslations.where(:translation1_id => t1.id, :translation2_id => t2.id)
          rt ||= RelatedTranslations.new(:translation1_id => t1.id, :translation2_id => t2.id, :share_meaning => false, :share_audible_form => false)

          rt.share_written_form = true
          rt.save!
        end
      end
    end

    share_form_results.count
  end

  def relate_all_that_share_pronunciation
    share_pronunciaton_sql = <<-SQL
      SELECT pronunciation, language_id, count(*)
      FROM translations t1
      GROUP BY pronunciation, language_id
      HAVING count(*) > 1
    SQL

    share_pronunciation_results = ActiveRecord::Base.connection.execute(share_pronunciaton_sql)
    share_pronunciation_results.each do |share_form|
      t1_set = Translation.where(:form => share_form["pronunciation"], :language_id => share_form["language_id"])
      t2_set = t1_set

      t1_set.each do |t1|
        t2_set.each do |t2|
          next if t1.id == t2.id

          rt = get_first RelatedTranslations.where(:translation1_id => t1.id, :translation2_id => t2.id)
          rt ||= RelatedTranslations.new(:translation1_id => t1.id, :translation2_id => t2.id, :share_meaning => false, :share_written_form => false)

          rt.share_audible_form = true
          rt.save!
        end
      end
    end

    share_pronunciation_results.count
  end

  def relate_all_that_share_meaning
    share_meaning_sql = <<-SQL
      SELECT it.idiom_id as idiom_id, t.language_id as languagei_id, count(*)
      FROM idiom_translations it
      JOIN translations t on t.id = it.translation_id
      GROUP BY it.idiom_id, t.language_id
      HAVING count(*) > 1
    SQL

    share_meaning_results = ActiveRecord::Base.connection.execute(share_meaning_sql)
    share_meaning_results.each do |share_meaning|
      t1_set = IdiomTranslation.joins(:translation).where(:idiom_id => share_meaning["idiom_id"], :translations => {:language_id => share_meaning["language_id"]})
      t2_set = t1_set

      t1_set.each do |t1|
        t2_set.each do |t2|
          next if t1.id == t2.id


          rt = get_first RelatedTranslations.where(:translation1_id => t1.translation_id, :translation2_id => t2.translation_id)
          rt ||= RelatedTranslations.new(:translation1_id => t1.translation_id, :translation2_id => t2.translation_id, :share_audible_form => false, :share_written_form => false)

          rt.share_meaning = true
          rt.save!
        end
      end
    end

    share_meaning_results.count
  end
end