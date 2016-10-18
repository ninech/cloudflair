require 'spec_helper'
require 'faraday'
require 'faraday_middleware'
require 'uri'

describe Connection do
  context 'email and key' do
    before do
      Cloudflair.configure do |config|
        config.cloudflare.auth.key = 'MY_AUTH_KEY'
        config.cloudflare.auth.email = 'MY_AUTH_EMAIL'
        config.cloudflare.auth.user_service_key = nil
        config.cloudflare.api_base_url = 'https://cloudflair.mock.local'
        config.faraday.adapter = :net_http
      end
    end

    it 'returns a Faraday::Connection' do
      expect(Connection.new).to be_a Faraday::Connection
    end

    it 'correctly sets the base url' do
      expect(Connection.new.url_prefix).
        to eq(URI.parse('https://cloudflair.mock.local'))
    end

    it 'sets the correct auth headers' do
      actual_headers = Connection.new.headers
      expect(actual_headers['X-Auth-Key']).to eq 'MY_AUTH_KEY'
      expect(actual_headers['X-Auth-Email']).to eq 'MY_AUTH_EMAIL'
      expect(actual_headers['X-Auth-User-Service-Key']).to be_nil
    end

    it 'sets the adapter' do
      expect(Connection.new.builder.handlers).to include Faraday::Adapter::NetHttp
    end

    it 'adds the json middleware' do
      expect(Connection.new.builder.handlers).to include FaradayMiddleware::ParseJson
    end
  end

  context 'user service key' do
    before do
      Cloudflair.configure do |config|
        config.cloudflare.auth.key = nil
        config.cloudflare.auth.email = nil
        config.cloudflare.auth.user_service_key = 'MY_AUTH_USER_SERVICE_KEY'
        config.cloudflare.api_base_url = 'https://cloudflair.mock.local'
        config.faraday.adapter = :net_http_persistent
      end
    end

    it 'sets the correct auth headers' do
      actual_headers = Connection.new.headers
      expect(actual_headers['X-Auth-Key']).to be_nil
      expect(actual_headers['X-Auth-Email']).to be_nil
      expect(actual_headers['X-Auth-User-Service-Key']).to eq 'MY_AUTH_USER_SERVICE_KEY'
    end
  end

  context 'alternative adapter' do
    before do
      Cloudflair.configure do |config|
        config.cloudflare.auth.user_service_key = 'MY_AUTH_USER_SERVICE_KEY'
        config.faraday.adapter = :net_http_persistent
      end
    end

    it 'sets the adapter' do
      expect(Connection.new.builder.handlers).to include Faraday::Adapter::NetHttpPersistent
    end
  end
end
