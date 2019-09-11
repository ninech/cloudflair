# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::DnsRecord do
  subject { Cloudflair.zone(zone_identifier).dns_record(record_identifier) }

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:record_identifier) { '372e67954025e0ba6aaa6d586b9e0b59' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/dns_record.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/dns_records/#{record_identifier}" }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'loads the data on demand and caches' do
    expect(faraday).to receive(:get).once.and_call_original

    expect(subject.id).to eq record_identifier
    expect(subject.name).to eq 'example.com'
    expect(subject.type).to eq 'A'
    expect(subject.content).to eq '1.2.3.4'
    expect(subject.ttl).to be 120
    expect(subject.locked).to be false
  end

  it 'reloads the AvailablePlan on request' do
    expect(faraday).to receive(:get).twice.and_call_original

    expect(subject.reload).to be subject
    expect(subject.reload).to be subject
  end

  describe '#delete' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/dns_record_deleted.json') }

    before do
      faraday_stubs.delete(url) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'performs the delete' do
      expect(faraday).to receive(:delete).once.and_call_original

      subject.delete
    end
  end
end
