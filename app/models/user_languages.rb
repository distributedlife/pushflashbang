class UserLanguages < ActiveRecord::Base
  attr_accessible :language_id, :user_id

  belongs_to :language
  belongs_to :user
end
