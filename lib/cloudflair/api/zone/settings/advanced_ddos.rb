require 'cloudflair/entity'

module Cloudflair
  class AdvancedDdos
    include Cloudflair::Entity

    attr_reader :zone_id

    path 'zones/:zone_id/settings/advanced_ddos'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
