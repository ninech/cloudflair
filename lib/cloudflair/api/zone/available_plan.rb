# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class AvailablePlan
    include Cloudflair::Entity

    attr_reader :zone_id, :plan_id

    path 'zones/:zone_id/available_plans/:plan_id'

    def initialize(zone_id, plan_id)
      @zone_id = zone_id
      @plan_id = plan_id
    end
  end
end
