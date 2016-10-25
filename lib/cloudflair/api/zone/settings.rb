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
require 'cloudflair/api/zone/settings/mobile_redirect'

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
      mobile_redirect: Cloudflair::MobileRedirect,
    }.each do |method, klass|
      define_method method do
        klass.new @zone_id
      end
    end
  end
end
