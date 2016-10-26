require 'cloudflair/entity'

module Cloudflair
  class DnsRecord
    include Cloudflair::Entity

    attr_reader :zone_id, :record_id
    path 'zones/:zone_id/dns_records/:record_id'

    def initialize(zone_id, record_id)
      @zone_id = zone_id
      @record_id = record_id
    end
  end
end
