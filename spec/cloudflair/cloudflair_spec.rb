require 'spec_helper'

describe Cloudflair do
  it 'has a version number' do
    expect(File.read('VERSION')).not_to be nil
  end

  it 'is configurable' do
    Cloudflair.configure do |config|
      config.cloudflare.auth.key = 'MY_AUTH_KEY'
      config.cloudflare.auth.email = 'MY_AUTH_EMAIL'
      config.cloudflare.auth.user_service_key = 'MY_AUTH_USER_SERVICE_KEY'
      config.cloudflare.api_base_url = 'https://cloudflair.mock.local'
      config.faraday.adapter = :net_http_persistent
    end

    expect(Cloudflair.config.cloudflare.auth.key).to eq 'MY_AUTH_KEY'
    expect(Cloudflair.config.cloudflare.auth.email).to eq 'MY_AUTH_EMAIL'
    expect(Cloudflair.config.cloudflare.auth.user_service_key).to eq 'MY_AUTH_USER_SERVICE_KEY'
    expect(Cloudflair.config.cloudflare.api_base_url).to eq 'https://cloudflair.mock.local'
    expect(Cloudflair.config.faraday.adapter).to be :net_http_persistent
  end
end
