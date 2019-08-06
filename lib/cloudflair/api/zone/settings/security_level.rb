# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class SecurityLevel
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/security_level'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
