require 'spec_helper'

describe Cloudflair::AdvancedDdos do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read("spec/cloudflair/fixtures/zone/settings/#{setting_identifier}.json") }
  let(:url) { "/client/v4/zones/#{zone_identifier}/settings/#{setting_identifier}" }
  let(:subject) { Cloudflair.zone(zone_identifier).settings.public_send setting_identifier }

  let(:setting_identifier) { 'advanced_ddos' }
  let(:value) { 'on' }
  let(:new_value) { 'off' }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'returns the correct zone_id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  describe 'fetch values' do
    it 'fetches relevant values' do
      expect(subject.id).to eq setting_identifier
      expect(subject.value).to eq value
      expect(subject.editable).to be false
    end
  end

  # non-standard
  describe 'put values' do
    it 'does not save the value' do
      expect(faraday).to_not receive(:patch)

      expect { subject.value = new_value }.to raise_error NoMethodError

      subject.save

      expect(subject.value).to eq value
    end
  end
end
