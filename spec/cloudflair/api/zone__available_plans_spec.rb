require 'spec_helper'

describe Cloudflair::Zone, 'available_plans things' do
  before do
    allow(Faraday).to receive(:new).and_return faraday
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:url) { "/client/v4/zones/#{zone_identifier}/dns_records" }
  subject { Cloudflair.zone zone_identifier }

  describe '#available_plan' do
    it 'returns an AvailablePlan instance' do
      expect(subject.available_plan('abcdef')).to be_a Cloudflair::AvailablePlan
    end
  end

  describe '#available_plans' do
    let(:url) { "/client/v4/zones/#{zone_identifier}/available_plans" }
    let(:response_json) { File.read('spec/cloudflair/fixtures/zone/plans.json') }
    let(:available_plans) { subject.available_plans }

    before do
      faraday_stubs.get(url) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

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
end
