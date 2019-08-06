# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class EmailObfuscation
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/email_obfuscation'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
