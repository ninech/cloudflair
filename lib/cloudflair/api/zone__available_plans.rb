require 'cloudflair/api/zone/available_plan'

module Cloudflair
  class Zone
    def available_plans
      raw_plans = response connection.get("#{path}/available_plans")

      raw_plans.map do |raw_plan|
        zone = available_plan raw_plan['id']
        zone.data = raw_plan
        zone
      end
    end

    def available_plan(plan_id)
      Cloudflair::AvailablePlan.new zone_id, plan_id
    end
  end
end
