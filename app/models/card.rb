class Card < ActiveRecord::Base
  belongs_to :deck
  has_many :user_card_schedule

  attr_accessible :front, :back

  validates :front, :presence => true
  validates :deck_id, :presence => true
end
