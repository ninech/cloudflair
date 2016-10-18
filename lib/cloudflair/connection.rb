class Connection
  def self.new
    config = Cloudflair.config

    Faraday.new(url: config.cloudflare.api_base_url, headers: headers) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\bjson$/

      faraday.adapter config.faraday.adapter || Faraday.default_adapter
    end
  end

  def self.headers
    headers = {}
    cloudflare_auth_config = Cloudflair.config.cloudflare.auth
    if cloudflare_auth_config.user_service_key.nil?
      headers['X-Auth-Key'] = cloudflare_auth_config.key
      headers['X-Auth-Email'] = cloudflare_auth_config.email
    else
      headers['X-Auth-User-Service-Key'] = cloudflare_auth_config.user_service_key
    end
    headers
  end
end
