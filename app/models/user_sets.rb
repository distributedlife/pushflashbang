class UserSets < ActiveRecord::Base
  belongs_to :language
  
  attr_accessible :user_id, :set_id, :chapter, :language_id

  validates :user_id, :presence => true
  validates :set_id, :presence => true
  validates :language_id, :presence => true
  validates :chapter, :presence => true, :numericality => { :greater_than => 0 }
end
