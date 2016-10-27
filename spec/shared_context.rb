require 'spec_helper'

require 'cloudflair'
require 'faraday'
require 'faraday_middleware'

RSpec.shared_context 'connection setup' do
  let(:faraday_logger) { nil }
  let(:cloudflare_auth) { { key: 'test_api_key', email: 'test_account_email', user_service_key: nil } }
  let(:cloudflare_api_base_url) { 'https://api.cloudflare.com/client/v4/' }

  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: Cloudflair.config.cloudflare.api_base_url, headers: Cloudflair::Connection.headers) do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
      faraday.request faraday_logger if faraday_logger
    end
  end

  before do
    Cloudflair.configure do |config|
      config.cloudflare.auth.key = cloudflare_auth[:key]
      config.cloudflare.auth.email = cloudflare_auth[:email]
      config.cloudflare.auth.user_service_key = cloudflare_auth[:user_service_key]
      config.cloudflare.api_base_url = cloudflare_api_base_url
    end
  end
end
