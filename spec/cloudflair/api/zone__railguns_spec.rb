require 'spec_helper'

describe Cloudflair::Zone, 'railguns things' do
  before do
    allow(Faraday).to receive(:new).and_return faraday
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/railguns.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/railguns" }
  subject(:zone) { Cloudflair.zone zone_identifier }

  describe '#railgun' do
    it 'returns a DnsRecord instance' do
      expect(subject.railgun('abcdef')).to be_a Cloudflair::Railgun
    end
  end

  describe '#railguns' do
    subject { zone.railguns }

    it 'calls the other url' do
      expect(faraday).to receive(:get).once.and_call_original

      subject
    end

    it 'returns the correct types' do
      expect(subject).to be_a Array
      subject.each do |item|
        expect(item).to be_a Cloudflair::Railgun
      end
    end

    it 'returns the correct amount' do
      expect(subject.length).to be 1
    end

    it 'returns the correct values' do
      dns_record = subject[0]
      expect(dns_record.id).to eq 'e928d310693a83094309acf9ead50448'
      expect(dns_record.name).to eq 'My Railgun'
      expect(dns_record.enabled).to be true
      expect(dns_record.connected).to be true
    end
  end
end
