require 'cloudflair/api/zone/settings/advanced_ddos'
require 'cloudflair/api/zone/settings/development_mode'

module Cloudflair
  class Settings
    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def development_mode
      Cloudflair::DevelopmentMode.new @zone_id
    end

    def advanced_ddos
      Cloudflair::AdvancedDdos.new @zone_id
    end

    def always_online
      Cloudflair::AlwaysOnline.new @zone_id
    end
  end
end
