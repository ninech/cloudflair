require 'spec_helper'

describe Cloudflair::DevelopmentMode do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\bjson$/
    end
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/development_mode.json') }
  let(:url) { "/zones/#{zone_identifier}/settings/development_mode" }
  let(:subject) { Cloudflair.zone(zone_identifier).settings.development_mode }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json,]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'returns the correct zone_id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  describe 'fetch values' do
    it 'fetches relevant values' do
      expect(subject.value).to eq 'off'
      expect(subject.editable).to be true
      expect(subject.time_remaining).to be 3600
    end
  end
end
