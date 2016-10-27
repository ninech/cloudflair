require 'spec_helper'

describe Cloudflair::DevelopmentMode do
  subject(:development_mode) { Cloudflair.zone(zone_identifier).settings.public_send setting_identifier }

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read("spec/cloudflair/fixtures/zone/settings/#{setting_identifier}.json") }
  let(:url) { "/client/v4/zones/#{zone_identifier}/settings/#{setting_identifier}" }

  let(:setting_identifier) { 'development_mode' }
  let(:value) { 'off' }
  let(:new_value) { 'on' }

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
      expect(subject.editable).to be true
    end
  end

  describe 'put values' do
    before do
      faraday_stubs.patch(url, 'value' => new_value) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'saves the values' do
      expect(faraday).to receive(:patch).and_call_original
      subject.value = new_value
      subject.save

      expect(subject.value).to eq value
    end
  end

  describe '#time_remaining' do
    subject { development_mode.time_remaining }

    context 'when the development mode was on at least once' do
      it { is_expected.to eq 3600 }
    end

    context 'when the development mode was never on' do
      let(:response_json) { File.read('spec/cloudflair/fixtures/zone/settings/development_mode_without_time_remaining.json') }

      it { is_expected.to eq 0 }
    end
  end
end
