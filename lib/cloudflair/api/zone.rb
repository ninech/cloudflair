require 'cloudflair/api/zone/development_mode'
require 'cloudflair/communication'

module Cloudflair
  def self.zone(zone_id)
    Zone.new zone_id
  end

  class Zone
    include Cloudflair::Communication

    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end

    private

    def patchable_fields
      %w(paused vanity_name_servers plan)
    end

    def path
      "/zones/#{zone_id}"
    end
  end
end
