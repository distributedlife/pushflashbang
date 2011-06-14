class UserCardReview < ActiveRecord::Base
  attr_accessible :user_id, :card_id, :due, :review_start, :reveal, :result_recorded, :result_success, :interval, :review_type

  RESULTS = ['didnt_know', 'partial_correct', 'shaky_good', 'good']

  validates :user_id, :presence => true
  validates :card_id, :presence => true
  validates :due, :presence => true
  validates :review_start, :presence => true
  validates :reveal, :presence => true
  validates :result_recorded, :presence => true
  validates :result_success, :presence => true
  validates_inclusion_of :result_success, :in => RESULTS
  validates :interval, :presence => true
end
