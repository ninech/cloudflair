require 'cloudflair/entity'

module Cloudflair
  class AvailableRatePlan
    include Cloudflair::Entity

    attr_reader :zone_id
    array_object_fields :components
    path 'zones/:zone_id/available_rate_plans'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
