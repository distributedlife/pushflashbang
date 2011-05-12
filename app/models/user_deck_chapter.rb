class UserDeckChapter < ActiveRecord::Base
  attr_accessible :user_id, :deck_id, :chapter

  validates :user_id, :presence => true
  validates :deck_id, :presence => true
  validates :chapter, :presence => true, :numericality => { :greater_than => 0 }
end
