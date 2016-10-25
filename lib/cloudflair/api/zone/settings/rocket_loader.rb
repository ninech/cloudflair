require 'cloudflair/entity'

module Cloudflair
  class RocketLoader
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/rocket_loader'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
