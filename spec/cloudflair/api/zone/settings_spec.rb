require 'spec_helper'

describe Cloudflair::Settings do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  let(:subject) { Cloudflair.zone(zone_identifier).settings }

  it 'returns the correct zone_id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  { always_online: Cloudflair::AlwaysOnline,
    advanced_ddos: Cloudflair::AdvancedDdos,
    browser_cache_ttl: Cloudflair::BrowserCacheTtl,
    browser_check: Cloudflair::BrowserCheck,
    cache_level: Cloudflair::CacheLevel,
    challenge_ttl: Cloudflair::ChallengeTtl,
    development_mode: Cloudflair::DevelopmentMode,
    email_obfuscation: Cloudflair::EmailObfuscation,
    hotlink_protection: Cloudflair::HotlinkProtection,
    ip_geolocation: Cloudflair::IpGeolocation,
    ipv6: Cloudflair::Ipv6,
    minify: Cloudflair::Minify,
  }.each do |method, klass|
    it "returns an initialized #{method} object" do
      expect(subject.public_send(method)).to be_a klass
      expect(subject.public_send(method).zone_id).to eq zone_identifier
    end
  end
end
