require 'spec_helper'

describe Cloudflair::Settings do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  let(:subject) { Cloudflair.zone(zone_identifier).settings }

  it 'returns the correct zone_id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  it 'returns an initialized development_mode object' do
    expect(subject.development_mode).to be_a Cloudflair::DevelopmentMode
    expect(subject.development_mode.zone_id).to eq zone_identifier
  end
end
