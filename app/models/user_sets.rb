# -*- encoding : utf-8 -*-
class UserSets < ActiveRecord::Base
  belongs_to :language
  belongs_to :user
  belongs_to :user_languages, :class_name => "UserLanguages", :primary_key => "language_id", :foreign_key => "language_id"
  
  attr_accessible :user_id, :set_id, :chapter, :language_id

  validates :user_id, :presence => true
  validates :set_id, :presence => true
  validates :language_id, :presence => true
  validates :chapter, :presence => true, :numericality => { :greater_than => 0 }

  def self.get_for_user_and_set_where_learning_language user_id, set_id
    UserSets.joins(:user_languages).where(:set_id => set_id, :user_id => user_id, :user_languages => {:user_id => user_id})
  end

  def due_count review_types
    UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(self.language_id, self.user_id, self.set_id, review_types)
  end

  def remaining_in_chapter review_types
    UserIdiomSchedule.get_count_of_remaining_terms_for_user_for_set_for_chapter_for_proficiencies(self.language_id, self.user.native_language_id, self.user_id, self.set_id, review_types, self.chapter)
  end

  def remaining_in_set review_types
    UserIdiomSchedule.get_count_of_remaining_terms_for_user_for_set_for_proficiencies(self.language_id, self.user.native_language_id, self.user_id, self.set_id, review_types)
  end
end
