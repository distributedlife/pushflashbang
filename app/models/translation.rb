class Translation < ActiveRecord::Base
  has_paper_trail

  attr_accessible :language, :form, :pronunciation

  validates :language, :presence => true
  validates :form, :presence => true
  validates :idiom_id, :presence => true
end