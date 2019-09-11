# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::Railgun do
  subject(:railgun) { Cloudflair.zone(zone_identifier).railgun(railgun_identifier) }

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:railgun_identifier) { 'e928d310693a83094309acf9ead50448' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/railgun.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/railguns/#{railgun_identifier}" }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'loads the data on demand and caches' do
    expect(faraday).to receive(:get).once.and_call_original

    expect(subject.id).to eq railgun_identifier
    expect(subject.name).to eq 'My Railgun'
    expect(subject.enabled).to be true
    expect(subject.connected).to be true
  end

  describe '#reload' do
    it 'reloads the AvailablePlan on request' do
      expect(faraday).to receive(:get).twice.and_call_original

      expect(subject.reload).to be subject
      expect(subject.reload).to be subject
    end
  end

  describe '#diagnose' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/railgun_diagnose.json') }
    let(:url) { "/client/v4/zones/#{zone_identifier}/railguns/#{railgun_identifier}/diagnose" }
    let(:railgun) { subject.diagnose }

    it 'calls the diagnose endpoint' do
      expect(faraday).to receive(:get).and_call_original

      expect(railgun).not_to be_nil
      expect(railgun).not_to be_a Hash
    end

    it 'returns the right values' do
      expect(railgun._method).to eq 'GET'
      expect(railgun.host_name).to eq 'www.example.com'
      expect(railgun.connection_close).to be false
      expect(railgun.cf_wan_error).to be_nil
    end
  end
end
