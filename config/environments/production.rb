Footprints::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Request craftsmen from Warehouse
  config.prefetch_craftsmen = false

  MAILER_CONFIG = YAML.load_file(Rails.root.join("config", "mailer.yml"))
  ENV['FOOTPRINTS_TEAM'] = "footprints@abcinc.com"
  ENV['STEWARD'] = MAILER_CONFIG['apprenticeship_steward']
  ENV['ADMIN_EMAIL'] = "footprints@abcinc.com"
  ENV['APPLICANTS_REVIEWER'] = "footprints@abcinc.com"
  ENV['warehouse-host'] = "https://warehouse-staging.abcinc.com"
  ENV['SALARY_YML_DOC'] = "./lib/argon/salaries.yml"
end
