class Deck < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :description, :lang, :country, :shared

  validates :name, :presence => true, :length => { :maximum => 40 }
  validates :lang, :presence => true, :length => { :maximum => 3 }
  validates :country, :presence => true, :length => { :maximum => 3 }
  validates :user_id, :presence => true
end
