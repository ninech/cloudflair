# frozen_string_literal: true

require 'spec_helper'
require 'faraday/detailed_logger'

describe Cloudflair::PurgeCache do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/purge_cache.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/purge_cache" }
  let(:subject) { Cloudflair.zone(zone_identifier).purge_cache }

  before do
    allow(Faraday).to receive(:new).and_return faraday
  end

  describe '#everything' do
    before do
      faraday_stubs.post(url) do |env|
        expect(env.body).to eq(purge_everything: true)

        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'deletes all files' do
      expect(faraday).to receive(:post).and_call_original

      expect(subject.everything(true)).to be subject
    end

    it 'is repeatedly executed' do
      expect(faraday).to receive(:post).twice.and_call_original

      expect(subject.everything(true)).to be subject
      expect(subject.everything(true)).to be subject
    end

    context 'invalid response' do
      let(:response_json) { '{"foo":"bar"}' }

      it 'raises an error' do
        expect { subject.everything(true) }.to raise_error Cloudflair::CloudflairError
      end
    end
  end

  describe '#selective' do
    let(:selective_list) { { tags: ['hello'], files: ['https://foo.bar/index.html'] } }

    before do
      faraday_stubs.post(url) do |env|
        expect(env.body).to eq(selective_list)

        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'deletes all files' do
      expect(faraday).to receive(:post).and_call_original

      expect(subject.selective(selective_list)).to be subject
    end

    it 'is repeatedly executed' do
      expect(faraday).to receive(:post).twice.and_call_original

      expect(subject.selective(selective_list)).to be subject
      expect(subject.selective(selective_list)).to be subject
    end

    context 'invalid response' do
      let(:response_json) { '{"foo":"bar"}' }

      it 'raises an error' do
        expect { subject.selective(selective_list) }.to raise_error Cloudflair::CloudflairError
      end
    end
  end
end
