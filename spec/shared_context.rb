# frozen_string_literal: true

require 'spec_helper'

require 'cloudflair'
require 'faraday'
require 'faraday_middleware'
require 'faraday/detailed_logger'

RSpec.shared_context 'connection setup' do
  let(:cloudflare_api_base_url) { 'https://api.cloudflare.com/client/v4/' }

  let(:cloudflare_auth) do
    {
      key:              'test_api_key',
      email:            'test_account_email',
      user_service_key: nil
    }
  end

  let(:faraday) do
    Faraday.new(
      url:     Cloudflair.config.cloudflare.api_base_url,
      headers: Cloudflair::Connection.headers
    ) do |faraday|
      faraday.response :json, content_type: /\bjson$/
      faraday.response faraday_logger if faraday_logger
      faraday.adapter :test, faraday_stubs
    end
  end

  let(:faraday_logger) { :detailed_logger }
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }

  before do
    Cloudflair.configure do |config|
      config.cloudflare.auth.key              = cloudflare_auth[:key]
      config.cloudflare.auth.email            = cloudflare_auth[:email]
      config.cloudflare.auth.user_service_key = cloudflare_auth[:user_service_key]
      config.cloudflare.api_base_url          = cloudflare_api_base_url
    end
  end
end
