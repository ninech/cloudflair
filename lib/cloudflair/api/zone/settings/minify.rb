# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class Minify
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/minify'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
