# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::CustomHostname do
  subject { Cloudflair.zone(zone_identifier).custom_hostname(hostname_identifier) }

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:hostname_identifier) { '0d89c70d-ad9f-4843-b99f-6cc0252067e9' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/custom_hostname.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/custom_hostnames/#{hostname_identifier}" }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'loads the data on demand and caches' do
    expect(faraday).to receive(:get).once.and_call_original

    expect(subject.id).to eq hostname_identifier
    expect(subject.hostname).to eq 'app.example.com'
  end

  it 'reloads the AvailablePlan on request' do
    expect(faraday).to receive(:get).twice.and_call_original

    expect(subject.reload).to be subject
    expect(subject.reload).to be subject
  end

  describe '#delete' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/custom_hostname_deleted.json') }

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
