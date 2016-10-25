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
    mirage: Cloudflair::Mirage,
    mobile_redirect: Cloudflair::MobileRedirect,
    origin_error_page_pass_thru: Cloudflair::OriginErrorPagePassThru,
    polish: Cloudflair::Polish,
    prefetch_preload: Cloudflair::PrefetchPreload,
    response_buffering: Cloudflair::ResponseBuffering,
    rocket_loader: Cloudflair::RocketLoader,
    security_header: Cloudflair::SecurityHeader,
    security_level: Cloudflair::SecurityLevel,
    server_side_exclude: Cloudflair::ServerSideExclude,
    sort_query_string_for_cache: Cloudflair::SortQueryStringForCache,
    ssl: Cloudflair::Ssl,
    tls_client_auth: Cloudflair::TlsClientAuth,
    tls_1_2_only: Cloudflair::Tls12Only,
    tls_1_3: Cloudflair::Tls13,
    true_client_ip_header: Cloudflair::TrueClientIpHeader,
    waf: Cloudflair::Waf,
    websockets: Cloudflair::Websockets,
  }.each do |method, klass|
    it "returns an initialized #{method} object" do
      expect(subject.public_send(method)).to be_a klass
      expect(subject.public_send(method).zone_id).to eq zone_identifier
    end
  end
end
