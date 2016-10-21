require 'spec_helper'

describe Cloudflair do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  describe '#zone' do
    it 'returns a zone object' do
      expect(subject.zone zone_identifier).to_not be_nil
      expect(subject.zone zone_identifier).to be_a Cloudflair::Zone
    end

    it 'returns the correct zone object' do
      expect(subject.zone(zone_identifier).zone_id).to eq zone_identifier
    end

    it 'returns a new zone every time' do
      a=subject.zone zone_identifier
      b=subject.zone zone_identifier

      expect(a).to_not be_nil
      expect(b).to_not be_nil

      expect(a).to be_a Cloudflair::Zone
      expect(b).to be_a Cloudflair::Zone

      expect(a.zone_id).to eq zone_identifier
      expect(b.zone_id).to eq zone_identifier

      expect(a).to_not be b
      expect(b).to_not be a
    end
  end

  describe '#zones' do
    let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:faraday) do
      Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
        faraday.adapter :test, faraday_stubs
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
      end
    end

    let(:response_json) { File.read('spec/cloudflair/fixtures/zones.json') }
    let(:subject) { Cloudflair.zone zone_identifier }
    let(:expected_params) { {} }
    let(:url) { '/client/v4/zones' }

    before do
      faraday_stubs.get(url) do |env|
        expect(env.url.query).to eq(url_query)

        [200, { content_type: 'application/json' }, response_json]
      end
      allow(Faraday).to receive(:new).and_return faraday
    end

    context 'no filters' do
      let(:url_query) { nil }

      it 'calls the remote side' do
        expect(faraday).to receive(:get).and_call_original

        expect(Cloudflair.zones.length).to be 1
      end

      it 'returns an array of Zones' do
        zones = Cloudflair.zones
        expect(zones).to be_a Array

        zones.each do |zone|
          expect(zone).to be_a Cloudflair::Zone
        end
      end

      it 'returned Zones are pre-populated' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(Cloudflair.zones[0].name).to eq('example.com')
      end

      context 'no results' do
        let(:response_json) { File.read('spec/cloudflair/fixtures/no_zones.json') }

        it 'returns an empty Array' do
          zones = Cloudflair.zones
          expect(zones).to be_a Array
          expect(zones.length).to be 0
        end
      end
    end

    context 'filters' do
      context 'name' do
        let(:url_query) { 'name=Hello' }

        it 'calls the remote side with the query params' do
          expect(faraday).to receive(:get).and_call_original

          Cloudflair.zones name: 'Hello'
        end
      end
      context 'all combined' do
        let(:url_query) do
          'match=all&name=example.com&order=desc&page=1&per_page=20&status=active'
        end

        it 'calls the remote side with the query params' do
          expect(faraday).to receive(:get).and_call_original

          Cloudflair.zones name: 'example.com',
                           status: 'active',
                           page: 1,
                           per_page: 20,
                           order: 'desc',
                           match: 'all'
        end
      end
    end
  end
end
