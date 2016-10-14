require 'spec_helper'

describe Cloudflair do
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
    let(:faraday) { Faraday.new { |builder| builder.adapter :test, faraday_stubs } }
    let(:zone_details_response_json) { File.new('spec/cloudflair/fixtures/zone/details.json').gets }

    before do
      faraday_stubs.get('/zones/'+zone_identifier) do |_env|
        [200, {}, '']
      end
      allow(Faraday).to receive(:new).and_return faraday

      @zone = Cloudflair.zone zone_identifier
    end

    it 'fetches the name on request' do
      expect(@zone.name).to eq 'example.com'
    end
  end
end
