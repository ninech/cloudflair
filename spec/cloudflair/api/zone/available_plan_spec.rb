require 'spec_helper'

describe Cloudflair::AvailablePlan do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:plan_identifier) { 'e592fd9519420ba7405e1307bff33214' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/plan.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/available_plans/#{plan_identifier}" }
  subject { Cloudflair.zone(zone_identifier).available_plan(plan_identifier) }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'loads the data on demand and caches' do
    expect(faraday).to receive(:get).once.and_call_original

    expect(subject.name).to eq 'Pro Plan'
    expect(subject.price).to be 20
    expect(subject.can_subscribe).to be true
  end

  it 'reloads the AvailablePlan on request' do
    expect(faraday).to receive(:get).twice.and_call_original

    expect(subject.reload).to be subject
    expect(subject.reload).to be subject
  end
end
