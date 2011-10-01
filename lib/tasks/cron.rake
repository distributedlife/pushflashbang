desc "The daily task list"
task :cron => :environment do
  Delayed::Job.enqueue RemoveDuplicateTranslationsJob.new
end