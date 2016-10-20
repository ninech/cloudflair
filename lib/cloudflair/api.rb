require 'cloudflair/api/zone'

module Cloudflair
  def self.zone(zone_id)
    Zone.new zone_id
  end
end
