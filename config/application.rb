require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Egnet
  class Application < Rails::Application
    # Start up discord bot once server is running
    config.after_initialize do
      if ENV['BASE_WARS_BRANCH']
        DiscordBot.run
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    
    # Allow any external Websocket connections for matchmaking
    # TODO: Is this safe?
    config.action_cable.disable_request_forgery_protection = true
    # To allow requests from certain regex specifically:
    # config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/]
  end
end
