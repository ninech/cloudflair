require 'cloudflair/entity'

module Cloudflair
  class HotlinkProtection
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/hotlink_protection'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
