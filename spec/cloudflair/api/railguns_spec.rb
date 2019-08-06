# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::Railguns do
  subject { Cloudflair.railgun railgun_identifier }

  let(:railgun_identifier) { 'e928d310693a83094309acf9ead50448' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/railgun/railgun.json') }
  let(:url) { "/client/v4/railguns/#{railgun_identifier}" }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'knows the given railgun id' do
    expect(subject.railgun_id).to eq railgun_identifier
  end

  describe 'fetch values' do
    it 'fetches the data when asked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload
      subject.reload
    end

    it 'returns the correct name' do
      expect(subject.name).to eq 'My Railgun'
    end

    it 'returns the correct enabled status' do
      expect(subject.enabled).to be true
    end

    it 'returns the amount of zones connected' do
      expect(subject.zones_connected).to be 2
    end
  end

  describe '#update' do
    before do
      faraday_stubs.patch(url, 'enabled' => false) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      subject.enabled = false
      expect(subject.save).to be subject
      # false, because the response is loaded from the server!
      # this is a good way to check if the @dirty hash is cleaned
      expect(subject.enabled).to be true
    end
  end

  describe '#delete' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/railgun/delete.json') }

    before do
      faraday_stubs.delete(url) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'deletes the entity from the server' do
      expect(faraday).to receive(:delete).and_call_original

      expect(subject.delete).to be subject
    end

    it 'parses the response' do
      expect(subject.delete).to be subject
      expect(subject.id).to eq railgun_identifier
      expect { subject.name }.to raise_error NoMethodError
    end
  end

  describe '#zones' do
    subject { Cloudflair.railgun(railgun_identifier).zones }

    let(:url) { "/client/v4/railguns/#{railgun_identifier}/zones" }
    let(:response_json) { File.read('spec/cloudflair/fixtures/railgun/railgun_zones.json') }

    it 'fetches the associated zones' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject).not_to be_nil
      expect(subject).to be_an Array
    end

    it 'parses the correct values' do
      expect(subject.length).to be 1
      expect(subject[0].id).to eq '023e105f4ecef8ad9ca31a8372d0c353'
      expect(subject[0].name).to eq 'example.com'
      expect(subject[0].original_name_servers).to be_an Array
      expect(subject[0].original_name_servers.length).to be 2
    end
  end
end
