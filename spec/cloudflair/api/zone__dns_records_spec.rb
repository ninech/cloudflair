# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::Zone, 'dns_record things' do
  subject(:zone) { Cloudflair.zone zone_identifier }

  before do
    allow(Faraday).to receive(:new).and_return faraday
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:url) { "/client/v4/zones/#{zone_identifier}/dns_records" }

  describe '#dns_record' do
    it 'returns a DnsRecord instance' do
      expect(subject.dns_record('abcdef')).to be_a Cloudflair::DnsRecord
    end
  end

  describe '#new_dns_record=' do
    let(:new_dns_record_data) { { type: 'A', name: 'example.com', content: '127.0.0.1' } }
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/dns_record.json') }
    let(:the_new_dns_record) { subject.new_dns_record(new_dns_record_data) }

    before do
      faraday_stubs.post(url, new_dns_record_data) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'returns a new DnsRecord instance' do
      expect(faraday).to receive(:post).and_call_original

      expect(the_new_dns_record).to be_a Cloudflair::DnsRecord
    end

    it 'prepopulates the returned DnsRecord instance' do
      expect(faraday).not_to receive(:get)

      expect(the_new_dns_record.id).to eq('372e67954025e0ba6aaa6d586b9e0b59')
      expect(the_new_dns_record.ttl).to be 120
      expect(the_new_dns_record.locked).to be false
    end
  end

  describe '#dns_records' do
    subject { zone.dns_records }

    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/dns_records.json') }

    before do
      faraday_stubs.get(url) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'calls the other url' do
      expect(faraday).to receive(:get).once.and_call_original

      subject
    end

    it 'returns the correct types' do
      expect(subject).to be_a Array
      subject.each do |plan|
        expect(plan).to be_a Cloudflair::DnsRecord
      end
    end

    it 'returns the correct amount' do
      expect(subject.length).to be 1
    end

    it 'returns the correct values' do
      dns_record = subject[0]
      expect(dns_record.id).to eq '372e67954025e0ba6aaa6d586b9e0b59'
      expect(dns_record.type).to eq 'A'
      expect(dns_record.content).to eq '1.2.3.4'
      expect(dns_record.proxiable).to be true
      expect(dns_record.ttl).to be 120
      expect(dns_record.data).to be_a Hash
      expect(dns_record.data.empty?).to be true
    end
  end
end
