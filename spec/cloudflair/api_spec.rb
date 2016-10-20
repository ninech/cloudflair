require 'spec_helper'

describe Cloudflair do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  it 'returns a zone object' do
    expect(subject.zone zone_identifier).to_not be_nil
    expect(subject.zone zone_identifier).to be_a Cloudflair::Zone
  end

  it 'returns the correct zone object' do
    expect(subject.zone(zone_identifier).zone_id).to eq zone_identifier
  end

  it 'returns a new zone every time' do
    a=subject.zone zone_identifier
    b=subject.zone zone_identifier

    expect(a).to_not be_nil
    expect(b).to_not be_nil

    expect(a).to be_a Cloudflair::Zone
    expect(b).to be_a Cloudflair::Zone

    expect(a.zone_id).to eq zone_identifier
    expect(b.zone_id).to eq zone_identifier

    expect(a).to_not be b
    expect(b).to_not be a
  end
end
