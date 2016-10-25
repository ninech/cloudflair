require 'cloudflair/entity'

module Cloudflair
  class IpGeolocation
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/ip_geolocation'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
