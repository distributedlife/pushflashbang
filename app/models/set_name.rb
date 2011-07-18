class SetName < ActiveRecord::Base
  attr_accessible :name, :description, :sets_id

  validates :sets_id, :presence => true
  validates :name, :presence => true

  belongs_to :sets
end
