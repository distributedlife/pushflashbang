StatsD.server = '23.21.142.181:8125'
StatsD.mode = :production

UsersController.extend StatsD::Instrument
UsersController.statsd_measure :index, "#{ENV['BUILD_NUMBER']}.Users.index"