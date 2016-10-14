require 'cloudflair/zone/development_mode'

module Cloudflair
  def self.zone(zone_id)
    Zone.new zone_id
  end

  class Zone
    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def method_missing name, *args, &block
      if true

      end
    end

    private

    def fetch_zones

    end
  end
end
