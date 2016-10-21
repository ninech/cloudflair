require 'cloudflair/api/zone'
require 'cloudflair/communication'

module Cloudflair
  extend Cloudflair::Communication

  def self.zone(zone_id)
    Zone.new zone_id
  end

  def self.zones(filter = {})
    json_hashes = response self.connection.get('zones', filter)

    json_hashes.map do |json|
      zone = Zone.new(json['id'])
      zone.data=json
      zone
    end
  end
end
