Delayed::Worker.destroy_failed_jobs = false
silence_warnings do
  Delayed::Worker.sleep_delay = 60
  Delayed::Worker.max_attempts = 3
  Delayed::Worker.max_run_time = 6.hours
end


