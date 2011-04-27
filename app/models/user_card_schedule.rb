class UserCardSchedule < ActiveRecord::Base
  belongs_to :card
  belongs_to :user

  attr_accessible :user_id, :card_id, :due, :interval

  validates :user_id, :presence => true
  validates :card_id, :presence => true
  validates :due, :presence => true
  validates :interval, :presence => true

  def self.get_next_due_for_user user_id
    UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", user_id, Time.now])
  end
end
