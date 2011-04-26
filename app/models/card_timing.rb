class CardTiming < ActiveRecord::Base
  attr_accessible :seconds

  validates :seconds, :presence => true

  def self.get_first
    self.order(:seconds).first
  end

  def self.get_next current
    set = self.order(:seconds).find(:first, :conditions => ["seconds > ?", current])

    if set.nil?
      self.order(:seconds).last
    else
      set
    end
  end
end
