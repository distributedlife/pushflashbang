class SetTerms < ActiveRecord::Base
  attr_accessible :set_id, :term_id
  
  validates :set_id, :presence => true
  validates :term_id, :presence => true
end
