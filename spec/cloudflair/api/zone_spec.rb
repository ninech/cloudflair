require 'spec_helper'

describe Cloudflair::Zone do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  it 'returns a zone object' do
    expect(Cloudflair.zone zone_identifier).to_not be_nil
  end

  it 'knows the given zone id' do
    zone = Cloudflair.zone zone_identifier

    expect(zone.zone_id).to eq zone_identifier
  end

  describe 'fetch values' do
    let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:faraday) do
      Faraday.new do |faraday|
        faraday.adapter :test, faraday_stubs
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.response :json, :content_type => /\bjson$/
      end
    end
    let(:zone_details_response_json) { File.read('spec/cloudflair/fixtures/zone/details.json') }

    before do
      faraday_stubs.get('/zones/'+zone_identifier) do |_env|
        [
          200,
          {
            content_type: 'application/json'
          },
          zone_details_response_json,
        ]
      end
      allow(Faraday).to receive(:new).and_return faraday

      @zone = Cloudflair.zone zone_identifier
    end

    it 'fetches the data when aked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      @zone.get!
      @zone.get!
    end

    it 'returns itself when get!ing' do
      expect(@zone.get!).to be @zone
    end

    it 'fetches the name on request' do
      expect(@zone.name).to eq 'example.com'
    end
  end
end
