require 'cloudflair/api/zone/settings'
require 'cloudflair/api/zone/purge_cache'
require 'cloudflair/entity'

module Cloudflair
  class Zone
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :paused, :vanity_name_servers, :plan
    deletable true
    path 'zones/:zone_id'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def settings
      @settings ||= Cloudflair::Settings.new zone_id
    end

    def purge_cache
      @purge_cache ||= Cloudflair::PurgeCache.new zone_id
    end
  end
end
