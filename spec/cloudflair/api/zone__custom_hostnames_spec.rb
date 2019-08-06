# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::Zone, 'custom_hostname things' do
  subject(:zone) { Cloudflair.zone zone_identifier }

  before do
    allow(Faraday).to receive(:new).and_return faraday
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:url) { "/client/v4/zones/#{zone_identifier}/custom_hostnames" }

  describe '#custom_hostname' do
    it 'returns a Custom Hostname instance' do
      expect(subject.custom_hostname('abcdef')).to be_a Cloudflair::CustomHostname
    end
  end

  describe '#new_custom_hostname=' do
    let(:new_custom_hostname_data) { { hostname: 'app.example.com', ssl: { method: 'http', type: 'dv', settings: { http2: 'on', min_tls_version: '1.2', tls_1_3: 'on', ciphers: %w[ECDHE-RSA-AES128-GCM-SHA256 AES128-SHA] } } } }
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/custom_hostname.json') }
    let(:the_new_custom_hostname) { subject.new_custom_hostname(new_custom_hostname_data) }

    before do
      faraday_stubs.post(url, new_custom_hostname_data) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'returns a new CustomHostname instance' do
      expect(faraday).to receive(:post).and_call_original

      expect(the_new_custom_hostname).to be_a Cloudflair::CustomHostname
    end

    it 'prepopulates the returned CustomHostname instance' do
      expect(faraday).not_to receive(:get)

      expect(the_new_custom_hostname.id).to eq('0d89c70d-ad9f-4843-b99f-6cc0252067e9')
      expect(the_new_custom_hostname.hostname).to eq('app.example.com')
      expect(the_new_custom_hostname.ssl['type']).to eq('dv')
    end
  end

  describe '#custom_hostnames' do
    subject { zone.custom_hostnames }

    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/custom_hostnames.json') }

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
        expect(plan).to be_a Cloudflair::CustomHostname
      end
    end

    it 'returns the correct amount' do
      expect(subject.length).to be 1
    end

    it 'returns the correct values' do
      custom_hostname = subject[0]
      expect(custom_hostname.id).to eq '0d89c70d-ad9f-4843-b99f-6cc0252067e9'
      expect(custom_hostname.hostname).to eq 'app.example.com'
      expect(custom_hostname.ssl['type']).to eq 'dv'
    end
  end
end
