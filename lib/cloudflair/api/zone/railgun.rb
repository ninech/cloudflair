require 'cloudflair/entity'

module Cloudflair
  class Railgun
    include Cloudflair::Entity

    attr_reader :zone_id, :railgun_id
    patchable_fields :connected
    path 'zones/:zone_id/railguns/:railgun_id'

    def initialize(zone_id, railgun_id)
      @zone_id = zone_id
      @railgun_id = railgun_id
    end

    def diagnose
      raw_response = connection.get "#{path}/diagnose"
      parsed_response = response raw_response
      hash_to_object parsed_response
    end
  end
end
