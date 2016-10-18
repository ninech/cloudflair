require 'spec_helper'

describe Cloudflair::Zone do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\bjson$/
    end
  end
  let(:zone_details_response_json) { File.read('spec/cloudflair/fixtures/zone/details.json') }

  before do
    faraday_stubs.get('/zones/'+zone_identifier) do |_env|
      [200, { content_type: 'application/json' }, zone_details_response_json,]
    end
    allow(Faraday).to receive(:new).and_return faraday

    @zone = Cloudflair.zone zone_identifier
  end

  it 'returns a zone object' do
    expect(Cloudflair.zone zone_identifier).to_not be_nil
  end

  it 'knows the given zone id' do
    zone = Cloudflair.zone zone_identifier

    expect(zone.zone_id).to eq zone_identifier
  end

  describe 'fetch values' do
    it 'fetches the data when aked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      @zone.reload
      @zone.reload
    end

    it 'returns itself when get!ing' do
      expect(@zone.reload).to be @zone
    end

    it 'returns the correct name' do
      expect(@zone.name).to eq 'example.com'
    end

    it 'returns the correct name' do
      expect(@zone._name).to eq 'example.com'
    end

    it 'returns the correct paused status' do
      expect(@zone.paused).to be false
    end

    it 'returns the remaining development mode time' do
      expect(@zone.development_mode).to eq 7200
    end
  end

  describe 'send values' do
    before do
      faraday_stubs.patch('/zones/'+zone_identifier, { 'paused' => true }) do |_env|
        [200, { content_type: 'application/json' }, zone_details_response_json,]
      end
    end

    it 'returns the value set' do
      @zone.paused = true
      expect(@zone.paused).to be true
    end

    it 'returns the value set' do
      expect(faraday).to receive(:patch).and_call_original

      @zone.paused = true
      expect(@zone.patch).to be @zone
      # false, because the response is loaded from the server!
      # this is a good check, if the @dirty hash is cleaned
      expect(@zone.paused).to be false
    end

    it 'returns the value set' do
      expect(faraday).to receive(:patch).and_call_original

      expect(@zone.update(paused: true)).to be @zone
      expect(@zone.paused).to be false
    end
  end
end
