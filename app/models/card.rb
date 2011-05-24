class Card < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :deck
  has_many :user_card_schedule

  attr_accessible :front, :back, :pronunciation, :chapter

  validates :front, :presence => true
  validates :deck_id, :presence => true
  validates :chapter, :presence => true, :numericality => { :greater_than => 0 }
end
