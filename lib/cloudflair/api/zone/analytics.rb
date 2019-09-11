# frozen_string_literal: true

require 'cloudflair/entity'

module Cloudflair
  class Analytics
    include Cloudflair::Communication

    def initialize(zone_id)
      @path = "zones/#{zone_id}/analytics"
    end

    def dashboard(filter = {})
      raw_response = connection.get "#{@path}/dashboard", filter
      parsed_response = response raw_response
      hash_to_object parsed_response
    end

    def colos(filter = {})
      raw_response = connection.get "#{@path}/colos", filter
      parsed_responses = response raw_response
      parsed_responses.map do |parsed_response|
        hash_to_object parsed_response
      end
    end
  end
end
