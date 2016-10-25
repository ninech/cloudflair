require 'cloudflair/api/zone/settings/advanced_ddos'
require 'cloudflair/api/zone/settings/always_online'
require 'cloudflair/api/zone/settings/browser_cache_ttl'
require 'cloudflair/api/zone/settings/browser_check'
require 'cloudflair/api/zone/settings/cache_level'
require 'cloudflair/api/zone/settings/challenge_ttl'
require 'cloudflair/api/zone/settings/development_mode'
require 'cloudflair/api/zone/settings/email_obfuscation'
require 'cloudflair/api/zone/settings/hotlink_protection'
require 'cloudflair/api/zone/settings/ip_geolocation'
require 'cloudflair/api/zone/settings/ipv6'
require 'cloudflair/api/zone/settings/minify'
require 'cloudflair/api/zone/settings/mirage'
require 'cloudflair/api/zone/settings/mobile_redirect'
require 'cloudflair/api/zone/settings/origin_error_page_pass_thru'
require 'cloudflair/api/zone/settings/polish'
require 'cloudflair/api/zone/settings/prefetch_preload'
require 'cloudflair/api/zone/settings/response_buffering'
require 'cloudflair/api/zone/settings/rocket_loader'
require 'cloudflair/api/zone/settings/security_header'
require 'cloudflair/api/zone/settings/security_level'
require 'cloudflair/api/zone/settings/server_side_exclude'
require 'cloudflair/api/zone/settings/sort_query_string_for_cache'
require 'cloudflair/api/zone/settings/ssl'
require 'cloudflair/api/zone/settings/tls_client_auth'
require 'cloudflair/api/zone/settings/tls_1_2_only'
require 'cloudflair/api/zone/settings/tls_1_3'
require 'cloudflair/api/zone/settings/true_client_ip_header'
require 'cloudflair/api/zone/settings/waf'
require 'cloudflair/api/zone/settings/websockets'

module Cloudflair
  class Settings
    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end

    { advanced_ddos: Cloudflair::AdvancedDdos,
      always_online: Cloudflair::AlwaysOnline,
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
      define_method method do
        klass.new @zone_id
      end
    end
  end
end
