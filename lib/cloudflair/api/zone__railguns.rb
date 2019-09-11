# frozen_string_literal: true

require 'cloudflair/api/zone/railgun'

module Cloudflair
  class Zone
    def railguns(filter = {})
      raw_railguns = response connection.get("#{path}/railguns", filter)

      raw_railguns.map do |raw_railgun|
        railgun = railgun raw_railgun['id']
        railgun.data = raw_railgun
        railgun
      end
    end

    def railgun(railgun_id)
      Cloudflair::Railgun.new zone_id, railgun_id
    end
  end
end
