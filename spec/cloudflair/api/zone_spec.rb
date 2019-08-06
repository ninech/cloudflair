# frozen_string_literal: true

require 'spec_helper'

describe Cloudflair::Zone do
  subject { Cloudflair.zone zone_identifier }

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/details.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}" }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'knows the given zone id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  it 'returns the settings instance' do
    expect(subject.settings).to be_a Cloudflair::Settings
  end

  it 'returns the PurgeCache instance' do
    expect(subject.purge_cache).to be_a Cloudflair::PurgeCache
  end

  it 'returns the Analytics instance' do
    expect(subject.analytics).to be_a Cloudflair::Analytics
  end

  describe 'fetch values' do
    it 'fetches the data when asked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload
      subject.reload
    end

    it 'returns itself when get!ing' do
      expect(subject.reload).to be subject
    end

    it 'returns the correct name' do
      expect(subject.name).to eq 'example.com'
    end

    it 'returns the correct name' do
      expect(subject._name).to eq 'example.com'
    end

    it 'returns the correct paused status' do
      expect(subject.paused).to be false
    end

    it 'returns the remaining development mode time' do
      expect(subject.development_mode).to eq 7200
    end

    context '#plan' do
      it 'returns the plan as actual object' do
        expect(subject.plan).not_to be_a Hash
      end

      it 'passes all the values to the plan object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.plan.id).to eq 'e592fd9519420ba7405e1307bff33214'
      end

      it 'is possible to reload the plan object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.plan.name).to eq 'Pro Plan'
      end
    end

    context '#plan_pending' do
      it 'returns the pending plan as actual object' do
        expect(subject.plan_pending).not_to be_a Hash
      end

      it 'passes all the values to the plan_pending object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.plan_pending.id).to eq 'e592fd9519420ba7405e1307bff33214'
        expect(subject.plan_pending.price).to be 20
      end

      it 'is possible to reload the plan_pending object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.plan_pending.name).to eq 'Pro Plan'
      end
    end

    context '#owner' do
      it 'returns the `owner` as actual object' do
        expect(subject.owner).not_to be_a Hash
      end

      it 'passes all the value to the `owner` object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.owner.id).to eq '7c5dae5552338874e5053f2534d2767a'
        expect(subject.owner.email).to eq 'user@example.com'
      end

      it 'is possible to reload the `owner` object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject.owner.owner_type).to eq 'user'
      end
    end
  end

  describe '#update' do
    before do
      faraday_stubs.patch(url, 'paused' => true) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'returns the value that has been set' do
      subject.paused = true
      expect(subject.paused).to be true
    end

    it 'sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      subject.paused = true
      expect(subject.patch).to be subject
      # false, because the response is loaded from the server!
      # this is a good way to check if the @dirty hash is cleaned
      expect(subject.paused).to be false
    end

    it 'updates the value and sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      expect(subject.update(paused: true)).to be subject
      expect(subject.paused).to be false
    end
  end

  describe '#delete' do
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/delete.json') }

    before do
      faraday_stubs.delete(url) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'deletes the entity from the server' do
      expect(faraday).to receive(:delete).and_call_original

      expect(subject.delete).to be subject
    end

    it 'calls the server only once' do
      expect(faraday).to receive(:delete).once.and_call_original

      expect(subject.delete).to be subject
      expect(subject.delete).to be subject
    end

    it 'parses the response' do
      expect(subject.delete).to be subject
      expect(subject.id).to eq zone_identifier
      expect { subject.name }.to raise_error NoMethodError
    end
  end
end
