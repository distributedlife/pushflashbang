# configure statsd host and port.
PushFlashBang::Application.configure do
  config.vitals.enabled = true
  config.vitals.host = '23.21.142.181'
  config.vitals.port = 8125
	config.vitals.reporter = 'detailed_reporter'
end

