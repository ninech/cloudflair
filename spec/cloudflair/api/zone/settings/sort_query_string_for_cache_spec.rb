require 'spec_helper'

describe Cloudflair::SortQueryStringForCache do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
    end
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read("spec/cloudflair/fixtures/zone/#{setting_identifier}.json") }
  let(:url) { "/client/v4/zones/#{zone_identifier}/settings/#{setting_identifier}" }
  let(:subject) { Cloudflair.zone(zone_identifier).settings.public_send setting_identifier }

  let(:setting_identifier) { 'sort_query_string_for_cache' }
  let(:value) { 'off' }
  let(:new_value) { 'on' }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'returns the correct zone_id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  # non-standard (has no .id)
  describe 'fetch values' do
    it 'fetches relevant values' do
      expect(subject.value).to eq value
    end
  end

  # non-standard
  describe 'put values' do
    it 'does not save the value' do
      expect(faraday).to_not receive(:patch)

      expect { subject.value = new_value }.to raise_error NoMethodError

      subject.save

      expect(subject.value).to eq value
    end
  end
end
