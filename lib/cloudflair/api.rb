require 'cloudflair/api/zone'
require 'cloudflair/communication'

module Cloudflair
  extend Cloudflair::Communication

  def self.zone(zone_id)
    Zone.new zone_id
  end

  def self.zones(filter = {})
    raw_zones = response connection.get('zones', filter)

    raw_zones.map do |raw_zone|
      zone = Zone.new(raw_zone['id'])
      zone.data = raw_zone
      zone
    end
  end
end
