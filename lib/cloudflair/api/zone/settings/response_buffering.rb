# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class ResponseBuffering
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/response_buffering'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def value
      _raw_data!
    end
  end
end
