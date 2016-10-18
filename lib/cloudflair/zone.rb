require 'cloudflair/zone/development_mode'

module Cloudflair
  def self.zone(zone_id)
    Zone.new zone_id
  end

  class Zone
    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
      @dirty = {}
    end

    def get!
      @data = get_data
      self
    end

    def method_missing name, *args, &block
      # allow access to data that conflicts with pre-defined methods
      # e.g. write 'zone._save' instead of 'zone.save' to access the datapoint called 'save'
      name = name.to_s
      name = name[1..-1] if name.start_with?('_')

      #return dirty[name] if @dirty.keys.include? name
      return data[name] if data.keys.include? name

      # allow access to clean data as 'zone.name!' or 'zone._name!'
      #if name.end_with?('!') && data.keys.include?(name[0..-2])
      #  return data[name[0..2]]
      #end

      #if name.end_with? '=' && attr_writer?(name)
      #  @dirty[name[0..-2]] = args[0]
      #  return
      #end

      super(name, args, block)
    end

    private

    def data
      @data ||= get_data
    end

    def get_data
      response = connection.get("/zones/#{zone_id}")
      body = response.body

      fail CloudflareError.new body['errors'] unless body['success']

      body['result']
    end

    def connection
      Connection.new
    end
  end
end
