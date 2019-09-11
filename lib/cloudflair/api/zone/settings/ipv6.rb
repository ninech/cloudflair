# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class Ipv6
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/ipv6'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
