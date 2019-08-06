# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair, 'railguns' do
  let(:railgun_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  describe '#railgun' do
    it 'returns a railgun object' do
      expect(subject.railgun(railgun_identifier)).not_to be_nil
      expect(subject.railgun(railgun_identifier)).to be_a Cloudflair::Railguns
    end

    it 'returns the correct railgun object' do
      expect(subject.railgun(railgun_identifier).railgun_id).to eq railgun_identifier
    end

    it 'returns a new railgun every time' do
      a = subject.railgun railgun_identifier
      b = subject.railgun railgun_identifier

      expect(a).not_to be_nil
      expect(b).not_to be_nil

      expect(a).to be_a Cloudflair::Railguns
      expect(b).to be_a Cloudflair::Railguns

      expect(a.railgun_id).to eq railgun_identifier
      expect(b.railgun_id).to eq railgun_identifier

      expect(a).not_to be b
      expect(b).not_to be a
    end
  end

  describe '#railguns' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/railguns.json') }
    let(:expected_params) { {} }
    let(:url) { '/client/v4/railguns' }

    before do
      faraday_stubs.get(url) do |env|
        expect(env.url.query).to eq(url_query)

        [200, { content_type: 'application/json' }, response_json]
      end
      allow(Faraday).to receive(:new).and_return faraday
    end

    context 'no filters' do
      let(:url_query) { nil }

      it 'calls the remote side' do
        expect(faraday).to receive(:get).and_call_original

        expect(subject.railguns.length).to be 1
      end

      it 'returns an array of railguns' do
        railguns = subject.railguns
        expect(railguns).to be_a Array

        railguns.each do |railgun|
          expect(railgun).to be_a Cloudflair::Railguns
        end
      end

      it 'returned railguns are pre-populated' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.railguns[0].name).to eq('My Railgun')
      end
    end

    context 'filters' do
      let(:url_query) do
        'direction=desc&page=1&per_page=20'
      end

      it 'calls the remote side with the query params' do
        expect(faraday).to receive(:get).and_call_original

        subject.railguns page:      1,
                         per_page:  20,
                         direction: 'desc'
      end
    end
  end
end
