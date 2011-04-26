class Card < ActiveRecord::Base
  belongs_to :deck

  attr_accessible :front, :back

  validates :front, :presence => true
  validates :deck_id, :presence => true
end
