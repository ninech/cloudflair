require 'cloudflair/entity'

module Cloudflair
  class BrowserCacheTtl
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/browser_cache_ttl'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
