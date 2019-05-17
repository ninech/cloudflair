require 'cloudflair/entity'

module Cloudflair
  class CustomHostname
    include Cloudflair::Entity

    attr_reader :zone_id, :custom_hostname_id
    deletable true
    patchable_fields :ssl, :custom_origin_server, :custom_metadata
    path 'zones/:zone_id/custom_hostnames/:custom_hostname_id'

    def initialize(zone_id, custom_hostname_id)
      @zone_id = zone_id
      @custom_hostname_id = custom_hostname_id
    end
  end
end
