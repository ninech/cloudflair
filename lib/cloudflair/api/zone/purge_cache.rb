module Cloudflair
  class PurgeCache
    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def purge_all_files(purge_everything=false)

    end
  end
end
