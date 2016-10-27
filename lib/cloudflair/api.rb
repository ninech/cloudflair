require 'cloudflair/api/zone'
require 'cloudflair/api/railguns'
require 'cloudflair/communication'

module Cloudflair
  extend Cloudflair::Communication

  def self.zone(zone_id)
    Zone.new zone_id
  end

  def self.zones(filter = {})
    raw_zones = response connection.get 'zones', filter

    raw_zones.map do |raw_zone|
      zone = Zone.new(raw_zone['id'])
      zone.data = raw_zone
      zone
    end
  end

  def self.railgun(railgun_id)
    Railguns.new railgun_id
  end

  def self.railguns(filter = {})
    raw_railguns = response connection.get 'railguns', filter

    raw_railguns.map do |raw_railgun|
      railgun = Railguns.new(raw_railgun['id'])
      railgun.data = raw_railgun
      railgun
    end
  end
end
