module Cloudflair
  class DevelopmentMode
    attr_accessor :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end
  end
end
