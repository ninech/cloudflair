require 'cloudflair/api/zone/available_plan'
require 'cloudflair/api/zone/available_rate_plan'
require 'cloudflair/api/zone/purge_cache'
require 'cloudflair/api/zone/settings'
require 'cloudflair/entity'

module Cloudflair
  class Zone
    include Cloudflair::Entity

    attr_reader :zone_id

    patchable_fields :paused, :vanity_name_servers, :plan
    object_fields :plan, :plan_pending, :owner
    deletable true
    path 'zones/:zone_id'

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def settings
      Cloudflair::Settings.new zone_id
    end

    def purge_cache
      Cloudflair::PurgeCache.new zone_id
    end

    def available_rate_plans
      Cloudflair::AvailableRatePlan.new zone_id
    end

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
