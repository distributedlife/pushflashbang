class CardTiming < ActiveRecord::Base
  attr_accessible :seconds

  validates :seconds, :presence => true

  RANGE_START_THRESHOLD = 120
  RANGE = 60

  SECONDS_IN_MINUTE = 60
  MINUTES_IN_HOUR = 60
  HOURS_IN_DAY = 24
  DAYS_IN_MONTH = 30  #approx
  DAYS_IN_YEAR = 365

  SECONDS_IN_HOUR = MINUTES_IN_HOUR * SECONDS_IN_MINUTE
  SECONDS_IN_DAY = SECONDS_IN_HOUR * HOURS_IN_DAY
  SECONDS_IN_MONTH = SECONDS_IN_DAY * DAYS_IN_MONTH
  SECONDS_IN_YEAR = SECONDS_IN_DAY * DAYS_IN_YEAR

  NON_PERFECT_LIMIT = SECONDS_IN_DAY * 5  #cap the advance of shaky answers to 5
  ADVANCE_THRESHOLD = SECONDS_IN_HOUR - 1 #if you know it jump to here then increment

  def self.threshold
    RANGE_START_THRESHOLD
  end

  def self.range
    RANGE.to_i
  end

  def self.half_range
    (RANGE / 2).to_i
  end

  def self.variance_percent
    10
  end

  def self.get_max_variance
    1 + (variance_percent / 100)
  end

  def self.get_first
    self.order(:seconds).first
  end

  def self.get_next_no_random current
    set = self.order(:seconds).find(:first, :conditions => ["seconds > ?", current])

    if set.nil?
      next_interval = self.order(:seconds).last
    else
      next_interval = set
    end

    next_interval
  end

  def self.get_next current
    set = self.order(:seconds).find(:first, :conditions => ["seconds > ?", current])

    if set.nil?
      next_interval = self.order(:seconds).last
    else
      next_interval = set
    end

    if current >= threshold
      next_interval.seconds = apply_random_variation next_interval.seconds
    end

    next_interval
  end

  def self.get_next_advance current
    set = self.order(:seconds).find(:first, :conditions => ["seconds > ? and seconds > ?", current, ADVANCE_THRESHOLD])
    
    if set.nil?
      next_interval = self.order(:seconds).last
    else
      next_interval = set
    end

    if current >= threshold
      next_interval.seconds = apply_random_variation next_interval.seconds
    end

    next_interval
  end

  def self.apply_random_variation seconds
    percent_offset = (rand variance_percent) / 100
    percent_offset = percent_offset + 1

    seconds * percent_offset
  end
end
