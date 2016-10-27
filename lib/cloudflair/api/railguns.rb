require 'cloudflair/entity'

module Cloudflair
  class Railguns
    include Cloudflair::Entity

    attr_reader :railgun_id
    patchable_fields :enabled
    deletable true
    path 'railguns/:railgun_id'

    def initialize(railgun_id)
      @railgun_id = railgun_id
    end

    def zones
      raw_response = connection.get "#{path}/zones"
      parsed_responses = response raw_response
      parsed_responses.map do |parsed_response|
        hash_to_object parsed_response
      end
    end
  end
end
