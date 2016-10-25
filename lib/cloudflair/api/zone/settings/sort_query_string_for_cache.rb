require 'cloudflair/entity'

module Cloudflair
  class SortQueryStringForCache
    include Cloudflair::Entity

    attr_reader :zone_id

    path 'zones/:zone_id/settings/sort_query_string_for_cache'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def value
      _raw_data!
    end
  end
end
