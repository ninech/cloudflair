require 'cloudflair/api/zone/analytics'
require 'cloudflair/api/zone/available_plan'
require 'cloudflair/api/zone/available_rate_plan'
require 'cloudflair/api/zone/purge_cache'
require 'cloudflair/api/zone/settings'
require 'cloudflair/entity'

module Cloudflair
  class Zone
    include Cloudflair::Entity

    require 'cloudflair/api/zone__dns_records'
    require 'cloudflair/api/zone__available_plans'
    require 'cloudflair/api/zone__railguns'
    require 'cloudflair/api/zone__custom_hostnames'

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

    def analytics
      Cloudflair::Analytics.new zone_id
    end
  end
end
