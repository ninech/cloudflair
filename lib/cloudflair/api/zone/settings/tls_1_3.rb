# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class Tls13
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/tls_1_3'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def value
      _raw_data!
    end
  end
end
