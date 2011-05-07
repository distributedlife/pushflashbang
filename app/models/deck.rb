class Deck < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :description, :shared, :pronunciation_side

  SIDES = ['front', 'back']

  validates :name, :presence => true, :length => { :maximum => 40 }
  validates :user_id, :presence => true
  validates :pronunciation_side, :presence => true
  validates_inclusion_of :pronunciation_side, :in => SIDES
end
