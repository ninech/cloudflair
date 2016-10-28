require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'
require 'cloudflair/error/cloudflair_error'

module Cloudflair
  class Connection
    def self.new
      config = Cloudflair.config

      new_faraday_from config
    end

    def self.headers
      headers = {}
      cloudflare_auth_config = Cloudflair.config.cloudflare.auth
      if !(cloudflare_auth_config.key.nil? || cloudflare_auth_config.email.nil?)
        headers['X-Auth-Key'] = cloudflare_auth_config.key
        headers['X-Auth-Email'] = cloudflare_auth_config.email
      elsif !cloudflare_auth_config.user_service_key.nil?
        headers['X-Auth-User-Service-Key'] = cloudflare_auth_config.user_service_key
      else
        fail CloudflairError, 'Neither email & key nor user_service_key have been defined.'
      end
      headers
    end

    private_class_method def self.new_faraday_from(config)
      Faraday.new(url: config.cloudflare.api_base_url, headers: headers) do |faraday|
        faraday.request :json
        faraday.response config.faraday.logger if config.faraday.logger
        faraday.response :json, content_type: /\bjson$/

        faraday.adapter config.faraday.adapter || Faraday.default_adapter
      end
    end
  end
end
