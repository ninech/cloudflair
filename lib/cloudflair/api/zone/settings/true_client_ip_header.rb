require 'cloudflair/entity'

module Cloudflair
  class TrueClientIpHeader
    include Cloudflair::Entity

    attr_reader :zone_id
    patchable_fields :value
    path 'zones/:zone_id/settings/true_client_ip_header'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def value
      _raw_data!
    end
  end
end
