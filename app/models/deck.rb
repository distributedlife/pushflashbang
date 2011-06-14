class Deck < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user

  attr_accessible :name, :description, :shared, :pronunciation_side, :supports_written_answer, :review_types

  SIDES = ['front', 'back']

  READING = 1
  WRITING = 2
  TYPING = 4
  HEARING = 8
  SPEAKING = 16

  REVIEW_TYPES = [READING, WRITING, TYPING, HEARING, SPEAKING]

  validates :name, :presence => true, :length => { :maximum => 40 }
  validates :user_id, :presence => true
  validates :pronunciation_side, :presence => true
  validates_inclusion_of :pronunciation_side, :in => SIDES
end
