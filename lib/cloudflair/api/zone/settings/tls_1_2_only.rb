require 'cloudflair/entity'

module Cloudflair
  class Tls12Only
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/tls_1_2_only'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def value
      _raw_data!
    end
  end
end
