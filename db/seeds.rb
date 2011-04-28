# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

SECONDS_IN_MINUTE = 60
MINUTES_IN_HOUR = 60
HOURS_IN_DAY = 24
DAYS_IN_MONTH = 30  #approx
DAYS_IN_YEAR = 365

SECONDS_IN_HOUR = MINUTES_IN_HOUR * SECONDS_IN_MINUTE
SECONDS_IN_DAY = SECONDS_IN_HOUR * HOURS_IN_DAY
SECONDS_IN_MONTH = SECONDS_IN_DAY * DAYS_IN_MONTH
SECONDS_IN_YEAR = SECONDS_IN_DAY * DAYS_IN_YEAR

CardTiming.create(:seconds => 5)                            # 5 seconds
CardTiming.create(:seconds => 25)                           # 25 seconds
CardTiming.create(:seconds => SECONDS_IN_MINUTE * 2)        # 2 minutes
CardTiming.create(:seconds => SECONDS_IN_MINUTE * 10)       # 10 minutes
CardTiming.create(:seconds => SECONDS_IN_HOUR)              # 1 hour
CardTiming.create(:seconds => SECONDS_IN_HOUR * 5)          # 5 hours
CardTiming.create(:seconds => SECONDS_IN_DAY)               # 1 day
CardTiming.create(:seconds => SECONDS_IN_DAY * 5)           # 5 days
CardTiming.create(:seconds => SECONDS_IN_DAY * 25)          # 25 days
CardTiming.create(:seconds => SECONDS_IN_MONTH * 4)         # 4 months
CardTiming.create(:seconds => SECONDS_IN_YEAR * 2)          # 2 years