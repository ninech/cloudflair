# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class OriginErrorPagePassThru
    include Cloudflair::Entity

    attr_reader :zone_id

    path 'zones/:zone_id/settings/origin_error_page_pass_thru'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def value
      _raw_data!
    end
  end
end
