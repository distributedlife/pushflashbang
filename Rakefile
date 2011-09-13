# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

PushFlashBang::Application.load_tasks

namespace :prod do
  desc "Take backup"
  task :backup do
    sh "heroku pgbackups:capture --expire --app pushflashbang"
  end
end

namespace :staging do
  desc "Copy latest pord backup to staging"
  task :copyfromprod do
    sh "heroku pgbackups:restore DATABASE `heroku pgbackups:url --app pushflashbang` --app pushflashbang-preprod"
  end
end

desc "Package assets for production"
task :assets do
  sh "bundle exec jammit --base-url http://pushflashbang.com"
end