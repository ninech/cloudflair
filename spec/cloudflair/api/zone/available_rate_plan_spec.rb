require 'spec_helper'

describe Cloudflair::AvailableRatePlan do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
    end
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/available_rate_plans.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/available_rate_plans" }
  let(:subject) { Cloudflair::AvailableRatePlan.new zone_identifier }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'parses the simple values' do
    expect(faraday).to receive(:get).once.and_call_original

    expect(subject.id).to eq 'free'
    expect(subject.name).to eq 'Free Plan'
    expect(subject.currency).to eq 'USD'
    expect(subject.duration).to be 1
    expect(subject.frequency).to eq 'monthly'
  end

  it 'parses the components array' do
    components = subject.components

    expect(components).to be_a Array
    expect(components.length).to be 1

    component = components[0]
    expect(component).to_not be_a Hash
    expect(component.name).to eq 'page_rules'
    expect(component.default).to be 5
    expect(component.unit_price).to be 1
  end
end
