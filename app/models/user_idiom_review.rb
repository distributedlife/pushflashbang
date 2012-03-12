# -*- encoding : utf-8 -*-
class UserIdiomReview < ActiveRecord::Base
  attr_accessible :user_id, :idiom_id, :language_id, :review_type, :due, :review_start, :reveal, :result_recorded, :success, :interval

  READING = 1
  WRITING = 2
  TYPING = 4
  HEARING = 8
  SPEAKING = 16
  TRANSLATING = 32

  REVIEW_TYPES = [READING, WRITING, TYPING, HEARING, SPEAKING, TRANSLATING]

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
    review_type.downcase!
    
    return READING if review_type == 'reading'
    return WRITING if review_type == 'writing'
    return TYPING if review_type == 'typing'
    return HEARING if review_type == 'listening'
    return SPEAKING if review_type == 'speaking'
    return TRANSLATING if review_type == 'translating'

    return nil
  end
end
