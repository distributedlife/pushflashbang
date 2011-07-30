class UserSets < ActiveRecord::Base
  attr_accessible :user_id, :set_id, :chapter

  validates :user_id, :presence => true
  validates :set_id, :presence => true
  validates :chapter, :presence => true, :numericality => { :greater_than => 0 }
end
