require 'spec_helper'
require 'faraday'
require 'faraday_middleware'
require 'uri'

describe Cloudflair::Connection do
  context 'email and key' do
    before do
      Cloudflair.configure do |config|
        config.cloudflare.auth.key = 'c2547eb745079dac9320b638f5e225cf483cc5cfdda41'
        config.cloudflare.auth.email = 'user@example.com'
        config.cloudflare.auth.user_service_key = nil
        config.cloudflare.api_base_url = 'https://cloudflair.mock.local'
        config.faraday.adapter = :net_http
      end
    end

    it 'returns a Faraday::Connection' do
      expect(Cloudflair::Connection.new).to be_a Faraday::Connection
    end

    it 'correctly sets the base url' do
      expect(Cloudflair::Connection.new.url_prefix).
        to eq(URI.parse('https://cloudflair.mock.local'))
    end

    it 'sets the correct auth headers' do
      actual_headers = Cloudflair::Connection.new.headers
      expect(actual_headers['X-Auth-Key']).to eq 'c2547eb745079dac9320b638f5e225cf483cc5cfdda41'
      expect(actual_headers['X-Auth-Email']).to eq 'user@example.com'
      expect(actual_headers['X-Auth-User-Service-Key']).to be_nil
    end

    it 'sets the adapter' do
      expect(Cloudflair::Connection.new.builder.handlers).to include Faraday::Adapter::NetHttp
    end

    it 'adds the json middleware' do
      expect(Cloudflair::Connection.new.builder.handlers).to include FaradayMiddleware::ParseJson
    end
  end

  context 'user service key' do
    before do
      Cloudflair.configure do |config|
        config.cloudflare.auth.key = nil
        config.cloudflare.auth.email = nil
        config.cloudflare.auth.user_service_key = 'v1.0-e24fd090c02efcfecb4de8f4ff246fd5c75b48946fdf0ce26c59f91d0d90797b-cfa33fe60e8e34073c149323454383fc9005d25c9b4c502c2f063457ef65322eade065975001a0b4b4c591c5e1bd36a6e8f7e2d4fa8a9ec01c64c041e99530c2-07b9efe0acd78c82c8d9c690aacb8656d81c369246d7f996a205fe3c18e9254a'
        config.cloudflare.api_base_url = 'https://cloudflair.mock.local'
        config.faraday.adapter = :net_http_persistent
      end
    end

    it 'sets the correct auth headers' do
      actual_headers = Cloudflair::Connection.new.headers
      expect(actual_headers['X-Auth-Key']).to be_nil
      expect(actual_headers['X-Auth-Email']).to be_nil
      expect(actual_headers['X-Auth-User-Service-Key']).to eq 'v1.0-e24fd090c02efcfecb4de8f4ff246fd5c75b48946fdf0ce26c59f91d0d90797b-cfa33fe60e8e34073c149323454383fc9005d25c9b4c502c2f063457ef65322eade065975001a0b4b4c591c5e1bd36a6e8f7e2d4fa8a9ec01c64c041e99530c2-07b9efe0acd78c82c8d9c690aacb8656d81c369246d7f996a205fe3c18e9254a'
    end
  end

  context 'alternative adapter' do
    before do
      Cloudflair.configure do |config|
        config.cloudflare.auth.user_service_key = 'v1.0-e24fd090c02efcfecb4de8f4ff246fd5c75b48946fdf0ce26c59f91d0d90797b-cfa33fe60e8e34073c149323454383fc9005d25c9b4c502c2f063457ef65322eade065975001a0b4b4c591c5e1bd36a6e8f7e2d4fa8a9ec01c64c041e99530c2-07b9efe0acd78c82c8d9c690aacb8656d81c369246d7f996a205fe3c18e9254a'
        config.faraday.adapter = :net_http_persistent
      end
    end

    it 'sets the adapter' do
      expect(Cloudflair::Connection.new.builder.handlers).to include Faraday::Adapter::NetHttpPersistent
    end
  end
end
