class CardTiming < ActiveRecord::Base
  attr_accessible :seconds

  validates :seconds, :presence => true

  RANGE_START_THRESHOLD = 120
  RANGE = 60

  def self.threshold
    RANGE_START_THRESHOLD
  end

  def self.range
    RANGE.to_i
  end

  def self.half_range
    (RANGE / 2).to_i
  end

  def self.get_first
    self.order(:seconds).first
  end

  def self.get_next current
    set = self.order(:seconds).find(:first, :conditions => ["seconds > ?", current])

    if set.nil?
      next_interval = self.order(:seconds).last
    else
      next_interval = set
    end

    if current >= threshold
      next_interval.seconds = next_interval.seconds - half_range + (rand range) + 1
    end

    next_interval
  end
end
