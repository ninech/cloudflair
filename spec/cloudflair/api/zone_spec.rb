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
  let(:subject) { Cloudflair.zone zone_identifier }

  before do
    faraday_stubs.get('/zones/'+zone_identifier) do |_env|
      [200, { content_type: 'application/json' }, zone_details_response_json,]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'returns a zone object' do
    expect(subject).to_not be_nil
    expect(subject).to be_a Cloudflair::Zone
  end

  it 'knows the given zone id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  describe 'fetch values' do
    it 'fetches the data when asked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload
      subject.reload
    end

    it 'returns itself when get!ing' do
      expect(subject.reload).to be subject
    end

    it 'returns the correct name' do
      expect(subject.name).to eq 'example.com'
    end

    it 'returns the correct name' do
      expect(subject._name).to eq 'example.com'
    end

    it 'returns the correct paused status' do
      expect(subject.paused).to be false
    end

    it 'returns the remaining development mode time' do
      expect(subject._development_mode).to eq 7200
    end

    it 'returns the remaining development mode time' do
      expect(subject.development_mode).to be_a Cloudflair::DevelopmentMode
    end
  end

  describe 'send values' do
    before do
      faraday_stubs.patch('/zones/'+zone_identifier, { 'paused' => true }) do |_env|
        [200, { content_type: 'application/json' }, zone_details_response_json,]
      end
    end

    it 'returns the value that has been set' do
      subject.paused = true
      expect(subject.paused).to be true
    end

    it 'sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      subject.paused = true
      expect(subject.patch).to be subject
      # false, because the response is loaded from the server!
      # this is a good way to check if the @dirty hash is cleaned
      expect(subject.paused).to be false
    end

    it 'updates the value and sets PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      expect(subject.update(paused: true)).to be subject
      expect(subject.paused).to be false
    end
  end
end
