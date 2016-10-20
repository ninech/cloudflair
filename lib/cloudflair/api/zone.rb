require 'cloudflair/api/zone/settings'
require 'cloudflair/entity'

module Cloudflair
  def self.zone(zone_id)
    Zone.new zone_id
  end

  class Zone
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :paused, :vanity_name_servers, :plan
    deletable true

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def settings
      @settings ||= Cloudflair::Settings.new zone_id
    end

    private

    def path
      "zones/#{zone_id}"
    end
  end
end
