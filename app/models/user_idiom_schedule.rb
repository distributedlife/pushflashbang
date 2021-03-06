# -*- encoding : utf-8 -*-
class UserIdiomSchedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :idiom
  has_many :user_idiom_due_items, :class_name => "UserIdiomDueItems", :foreign_key => "user_idiom_schedule_id"

  attr_accessible :user_id, :idiom_id, :language_id

  validates :user_id, :presence => true
  validates :idiom_id, :presence => true
  validates :language_id, :presence => true

  def self.get_next_due_for_user language_id, user_id
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:first, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due", {:language_id => language_id, :user_id => user_id, :due => Time.now}])
  end

  def self.get_due_count_for_user language_id, user_id
    UserIdiomDueItems.select(:user_idiom_schedule_id).group(:user_idiom_schedule_id).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due", {:language_id => language_id, :user_id => user_id, :due => Time.now}]).count
  end


  def self.get_next_due_for_user_for_set language_id, user_id, set_id
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:first, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id}])
  end

  def self.get_due_count_for_user_for_set language_id, user_id, set_id
    UserIdiomDueItems.select(:user_idiom_schedule_id).group(:user_idiom_schedule_id).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id}]).count
  end


  def self.get_next_due_for_user_for_proficiencies language_id, user_id, proficiencies
    UserIdiomDueItems.joins(:user_idiom_schedule).find(:first, :order => "due ASC", :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND review_type IN (:review_types)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :review_types => proficiencies}])
  end

  def self.get_due_count_for_user_for_proficiencies language_id, user_id, proficiencies
    UserIdiomDueItems.select(:user_idiom_schedule_id).group(:user_idiom_schedule_id).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND review_type IN (:review_types)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :review_types => proficiencies}]).count
  end


  def self.get_next_due_for_user_for_set_for_proficiencies language_id, user_id, set_id, proficiencies
    sql = <<-SQL
      language_id = :language_id
      AND user_id = :user_id
      AND due <= :due
      AND review_type IN (:review_types)
      AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)
    SQL

    UserIdiomDueItems.joins(:user_idiom_schedule).find(:first, :order => "due ASC", :conditions => [sql, {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id, :review_types => proficiencies}])
  end

  def self.get_due_count_for_user_for_set_for_proficiencies language_id, user_id, set_id, proficiencies
    sql = <<-SQL
      language_id = :language_id
      AND user_id = :user_id
      AND due <= :due
      AND review_type IN (:review_types)
      AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)
    SQL

    UserIdiomDueItems.select(:user_idiom_schedule_id).group(:user_idiom_schedule_id).joins(:user_idiom_schedule).find(:all, :conditions => [sql, {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id, :review_types => proficiencies}]).count
  end

  def self.get_first_unscheduled_term_for_user_for_set_for_proficiencies language_id, user_native_language_id, user_id, set_id, proficiencies
    # get me the set_terms list
    # minus the terms the user has scheduled (for proficiencies)
    # minus the terms the language doesn't support
    # minus the terms that don't translate into the user's native language

    terms_the_user_can_learn = <<-SQL
      SELECT term_id
      FROM set_terms
      JOIN translations
        ON set_terms.term_id = translations.idiom_id
        AND translations.language_id = #{language_id}
      WHERE set_id = #{set_id}
    SQL
    
    terms_the_user_has_scheduled = <<-SQL
      SELECT idiom_id
      FROM user_idiom_schedules
      JOIN user_idiom_due_items
        ON user_idiom_schedules.id = user_idiom_due_items.user_idiom_schedule_id
        AND review_type in (#{proficiencies.join(',')})
      WHERE user_id = #{user_id}
    SQL

    terms_that_support_the_users_native_language = <<-SQL
      SELECT term_id
      FROM set_terms
      JOIN translations
        ON set_terms.term_id = translations.idiom_id
        AND translations.language_id = #{user_native_language_id}
      WHERE set_id = #{set_id}
    SQL

#    AND
#        (
#          translations.audio_file_name IS NOT NULL
#          AND #{UserIdiomReview::HEARING} IN (#{proficiencies.join(',')})
#        )


    sql = <<-SQL
      SELECT *
      FROM set_terms
      WHERE term_id in
      (
        #{terms_the_user_can_learn}
        intersect #{terms_that_support_the_users_native_language}
        except #{terms_the_user_has_scheduled}
      )
      AND set_id = #{set_id}
      ORDER BY
        chapter ASC,
        position ASC
    SQL

    next_terms = SetTerms.find_by_sql(sql)

    if next_terms.empty?
      nil
    else
      next_terms.first
    end
  end

  def self.get_count_of_remaining_terms_for_user_for_set_for_chapter_for_proficiencies language_id, user_native_language_id, user_id, set_id, proficiencies, user_set_chapter
    terms_the_user_can_learn = <<-SQL
      SELECT term_id
      FROM set_terms
      JOIN translations
        ON set_terms.term_id = translations.idiom_id
        AND translations.language_id = #{language_id}
      WHERE set_id = #{set_id}
      AND set_terms.chapter <= #{user_set_chapter}
    SQL

    terms_the_user_has_scheduled = <<-SQL
      SELECT idiom_id
      FROM user_idiom_schedules
      JOIN user_idiom_due_items
        ON user_idiom_schedules.id = user_idiom_due_items.user_idiom_schedule_id
        AND review_type in (#{proficiencies.join(',')})
      WHERE user_id = #{user_id}
    SQL

    terms_that_support_the_users_native_language = <<-SQL
      SELECT term_id
      FROM set_terms
      JOIN translations
        ON set_terms.term_id = translations.idiom_id
        AND translations.language_id = #{user_native_language_id}
      WHERE set_id = #{set_id}
    SQL

#    AND
#        (
#          translations.audio_file_name IS NOT NULL
#          AND #{UserIdiomReview::HEARING} IN (#{proficiencies.join(',')})
#        )


    sql = <<-SQL
      SELECT *
      FROM set_terms
      WHERE term_id in
      (
        #{terms_the_user_can_learn}
        intersect #{terms_that_support_the_users_native_language}
        except #{terms_the_user_has_scheduled}
      )
      AND set_id = #{set_id}
      ORDER BY
        chapter ASC,
        position ASC
    SQL

    SetTerms.find_by_sql(sql).count
  end

  def self.get_count_of_remaining_terms_for_user_for_set_for_proficiencies language_id, user_native_language_id, user_id, set_id, proficiencies
    terms_the_user_can_learn = <<-SQL
      SELECT term_id
      FROM set_terms
      JOIN translations
        ON set_terms.term_id = translations.idiom_id
        AND translations.language_id = #{language_id}
      WHERE set_id = #{set_id}
    SQL

    terms_the_user_has_scheduled = <<-SQL
      SELECT idiom_id
      FROM user_idiom_schedules
      JOIN user_idiom_due_items
        ON user_idiom_schedules.id = user_idiom_due_items.user_idiom_schedule_id
        AND review_type in (#{proficiencies.join(',')})
      WHERE user_id = #{user_id}
    SQL

    terms_that_support_the_users_native_language = <<-SQL
      SELECT term_id
      FROM set_terms
      JOIN translations
        ON set_terms.term_id = translations.idiom_id
        AND translations.language_id = #{user_native_language_id}
      WHERE set_id = #{set_id}
    SQL

#    AND
#        (
#          translations.audio_file_name IS NOT NULL
#          AND #{UserIdiomReview::HEARING} IN (#{proficiencies.join(',')})
#        )


    sql = <<-SQL
      SELECT *
      FROM set_terms
      WHERE term_id in
      (
        #{terms_the_user_can_learn}
        intersect #{terms_that_support_the_users_native_language}
        except #{terms_the_user_has_scheduled}
      )
      AND set_id = #{set_id}
      ORDER BY
        chapter ASC,
        position ASC
    SQL

    SetTerms.find_by_sql(sql).count
  end
end
