require 'spec_helper'

describe Cloudflair::Zone do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
    end
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/details.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}" }
  subject { Cloudflair.zone zone_identifier }

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

  it 'returns an AvailablePlan instance' do
    expect(subject.available_plan('abcdef')).to be_a Cloudflair::AvailablePlan
  end

  it 'returns a DnsRecord instance' do
    expect(subject.dns_record('abcdef')).to be_a Cloudflair::DnsRecord
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

    context '#available_plans' do
      let(:url) { "/client/v4/zones/#{zone_identifier}/available_plans" }
      let(:response_json) { File.read('spec/cloudflair/fixtures/zone/plans.json') }
      let(:available_plans) { subject.available_plans }

      it 'calls the other url' do
        expect(faraday).to receive(:get).once.and_call_original

        available_plans
      end

      it 'returns the correct types' do
        expect(available_plans).to be_a Array
        available_plans.each do |plan|
          expect(plan).to be_a Cloudflair::AvailablePlan
        end
      end

      it 'returns the correct amount' do
        expect(available_plans.length).to be 1
      end

      it 'returns the correct values' do
        plan = available_plans[0]
        expect(plan.id).to eq 'e592fd9519420ba7405e1307bff33214'
        expect(plan.price).to be 20
        expect(plan.is_subscribed).to be true
      end
    end

    context '#plan' do
      it 'returns the plan as actual object' do
        expect(subject.plan).to_not be_a Hash
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
        expect(subject.plan_pending).to_not be_a Hash
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
        expect(subject.owner).to_not be_a Hash
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

    context '#dns_records' do
      let(:url) { "/client/v4/zones/#{zone_identifier}/dns_records" }
      let(:response_json) { File.read('spec/cloudflair/fixtures/zone/dns_records.json') }
      let(:dns_records) { subject.dns_records }

      it 'calls the other url' do
        expect(faraday).to receive(:get).once.and_call_original

        dns_records
      end

      it 'returns the correct types' do
        expect(dns_records).to be_a Array
        dns_records.each do |plan|
          expect(plan).to be_a Cloudflair::DnsRecord
        end
      end

      it 'returns the correct amount' do
        expect(dns_records.length).to be 1
      end

      it 'returns the correct values' do
        dns_record = dns_records[0]
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

    it 'updates the value and sets PATCH to the server' do
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
