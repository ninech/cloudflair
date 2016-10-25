require 'cloudflair/entity'

module Cloudflair
  class MobileRedirect
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :value
    path 'zones/:zone_id/settings/mobile_redirect'

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
