class UserIdiomReview < ActiveRecord::Base
  attr_accessible :user_id, :idiom_id, :language_id, :review_type, :due, :review_start, :reveal, :result_recorded, :success, :interval

  READING = 1
  WRITING = 2
  TYPING = 4
  HEARING = 8
  SPEAKING = 16

  REVIEW_TYPES = [READING, WRITING, TYPING, HEARING, SPEAKING]

  validates :user_id, :presence => true
  validates :idiom_id, :presence => true
  validates :language_id, :presence => true
  validates :review_type, :presence => true
  validates_inclusion_of :review_type, :in => REVIEW_TYPES
  validates :due, :presence => true
  validates :review_start, :presence => true
  validates :reveal, :presence => true
  validates :result_recorded, :presence => true
  validates :interval, :presence => true

  def self.to_review_type_int review_type
    return READING if review_type == 'reading'
    return WRITING if review_type == 'writing'
    return TYPING if review_type == 'typing'
    return HEARING if review_type == 'listening'
    return SPEAKING if review_type == 'speaking'
  end
end
