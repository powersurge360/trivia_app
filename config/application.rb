require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MonsterTrivia
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_job.queue_adapter = :sidekiq
    config.log_level = ENV.fetch("RAILS_LOG_LEVEL") { "info" }.to_sym

    config.x.hashids_salt = ENV["HASHIDS_SALT"]

    config.x.google_analytics_key = ENV.fetch("GOOGLE_ANALYTICS_KEY", "")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
