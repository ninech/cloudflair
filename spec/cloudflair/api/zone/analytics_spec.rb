require 'spec_helper'

describe Cloudflair::DnsRecord do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  subject(:analytics) { Cloudflair.zone(zone_identifier).analytics }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  describe '#dashboard' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/analytics_dashboard.json') }
    let(:url) { "/client/v4/zones/#{zone_identifier}/analytics/dashboard" }
    subject { analytics.dashboard }

    it 'fetches the values' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject).to_not be_nil
      expect(subject).to_not be_a Hash
    end

    it 'does not cache the response' do
      expect(faraday).to receive(:get).twice.and_call_original

      a = analytics.dashboard
      b = analytics.dashboard

      expect(a).to_not be_nil
      expect(b).to_not be_nil

      expect(a).to_not be b
      expect(b).to_not be a
    end

    it 'returns the actual values' do
      expect(subject.totals).to_not be_nil
      expect(subject.totals).to be_a Hash
      expect(subject.totals['requests']['all']).to be 1234085328
      expect(subject.timeseries).to_not be_nil
      expect(subject.timeseries.length).to be 1
    end
  end

  describe '#colos' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/analytics_colos.json') }
    let(:url) { "/client/v4/zones/#{zone_identifier}/analytics/colos" }
    subject { analytics.colos }

    it 'fetches the values' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject).to_not be_nil
      expect(subject).to be_an Array
    end

    it 'does not cache the response' do
      expect(faraday).to receive(:get).twice.and_call_original

      a = analytics.colos
      b = analytics.colos

      expect(a).to_not be_nil
      expect(b).to_not be_nil

      expect(a).to_not be b
      expect(b).to_not be a
    end

    it 'returns the actual values' do
      expect(subject.length).to be 1
      expect(subject[0]).to_not be_a Hash
      expect(subject[0].colo_id).to eq 'SFO'
      expect(subject[0].timeseries).to_not be_nil
      expect(subject[0].timeseries.length).to be 1
    end
  end
end
