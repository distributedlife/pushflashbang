class UserIdiomDueItems < ActiveRecord::Base
  belongs_to :user_idiom_schedule, :class_name => "UserIdiomSchedule"

  attr_accessible :user_idiom_schedule_id, :review_type, :interval, :due

  validates :user_idiom_schedule_id, :presence => true
  validates :review_type, :presence => true
  validates :interval, :presence => true
  validates :due, :presence => true
end
