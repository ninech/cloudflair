require 'cloudflair/api'
require 'cloudflair/version'
require 'dry-configurable'

##
# To configure cloudflair
# <code>
# require "cloudflair"
# Cloudflair.configure do |config|
#   config.cloudflare.auth.key = 'YOUR_API_KEY'
#   config.cloudflare.auth.email = 'YOUR_ACCOUNT_EMAIL'
#   # if you have a user_service_key, you don't need auth.key and auth.email
#   config.cloudflare.auth.user_service_key = 'YOUR_USER_SERVICE_KEY'
#
#   # these are optional:
#
#   config.cloudflare.api_base_url = 'https://your_cloudflare_mock.local'
#   config.faraday.adapter = :your_preferred_faraday_adapter
#   # built-in options: :logger, :detailed_logger; default: nil
#   config.faraday.logger = :logger
# end
# </code>
module Cloudflair
  # Your code goes here...
  extend Dry::Configurable

  setting :cloudflare do
    setting :api_base_url, 'https://api.cloudflare.com/client/v4/'
    setting :auth do
      setting :key
      setting :email
      setting :user_service_key
    end
  end

  setting :faraday do
    setting :adapter, :net_http
    setting :logger
  end
end
