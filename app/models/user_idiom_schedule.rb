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
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due", {:language_id => language_id, :user_id => user_id, :due => Time.now}]).count
  end

  def self.get_next_due_for_user_for_set language_id, user_id, set_id
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:first, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id}])
  end

  def self.get_due_count_for_user_for_set language_id, user_id, set_id
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id}]).count
  end

  def self.get_next_due_for_user_for_proficiencies language_id, user_id, proficiencies
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:first, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND review_type IN (:review_types)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :review_types => proficiencies}])
  end

  def self.get_due_count_for_user_for_proficiencies language_id, user_id, proficiencies
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND review_type IN (:review_types)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :review_types => proficiencies}]).count
  end

  def self.get_next_due_for_user_for_set_for_proficiencies language_id, user_id, set_id, proficiencies
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:first, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND review_type IN (:review_types) AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id, :review_types => proficiencies}])
  end

  def self.get_due_count_for_user_for_set_for_proficiencies language_id, user_id, set_id, proficiencies
    UserIdiomDueItems.order(:due).joins(:user_idiom_schedule).find(:all, :conditions => ["language_id = :language_id AND user_id = :user_id AND due <= :due AND review_type IN (:review_types) AND idiom_id in (SELECT term_id FROM set_terms WHERE set_id = :set_id)", {:language_id => language_id, :user_id => user_id, :due => Time.now, :set_id => set_id, :review_types => proficiencies}]).count
  end
end
