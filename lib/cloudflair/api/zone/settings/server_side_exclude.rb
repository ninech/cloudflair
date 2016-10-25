require 'cloudflair/entity'

module Cloudflair
  class ServerSideExclude
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/server_side_exclude'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
