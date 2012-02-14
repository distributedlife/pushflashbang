PushFlashBang::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false
  config.assets.compress = false
  config.assets.debug = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost:3001" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings =
  {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'distributedlife.com',
    :user_name            => 'ryan.boucher@distributedlife.com',
    :password             => 'xxx',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  #devise performance for test and dev
  config.stretches = 1

  #disable craploads of paperclip logging
  Paperclip.options[:log] = false

  #bullet configuration
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
end

