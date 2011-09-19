Delayed::Worker.destroy_failed_jobs = false
silence_warnings do
  Delayed::Worker.sleep_delay = 60
  Delayed::Worker.max_attempts = 1
  Delayed::Worker.max_run_time = 12.hours
end


