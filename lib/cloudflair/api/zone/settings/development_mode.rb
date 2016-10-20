require 'cloudflair/communication'

module Cloudflair
  class DevelopmentMode
    include Cloudflair::Communication

    attr_accessor :zone_id

    patchable_fields :value

    def initialize(zone_id)
      @zone_id = zone_id
    end

    private

    def path
      "zones/#{zone_id}/settings/development_mode"
    end
  end
end
