require 'cloudflair/api/zone/settings/advanced_ddos'
require 'cloudflair/api/zone/settings/always_online'
require 'cloudflair/api/zone/settings/browser_cache_ttl'
require 'cloudflair/api/zone/settings/browser_check'
require 'cloudflair/api/zone/settings/cache_level'
require 'cloudflair/api/zone/settings/development_mode'

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
      development_mode: Cloudflair::DevelopmentMode,
    }.each do |method, klass|
      define_method method do
        klass.new @zone_id
      end
    end
  end
end
