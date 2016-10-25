require 'cloudflair/api/zone/settings/advanced_ddos'
require 'cloudflair/api/zone/settings/always_online'
require 'cloudflair/api/zone/settings/browser_cache_ttl'
require 'cloudflair/api/zone/settings/browser_check'
require 'cloudflair/api/zone/settings/cache_level'
require 'cloudflair/api/zone/settings/challenge_ttl'
require 'cloudflair/api/zone/settings/development_mode'
require 'cloudflair/api/zone/settings/email_obfuscation'

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
      email_obfuscation: Cloudflair::EmailObfuscation
    }.each do |method, klass|
      define_method method do
        klass.new @zone_id
      end
    end
  end
end
