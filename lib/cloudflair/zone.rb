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

    def revert
      @dirty.clear
    end

    def reload
      @data = get
      revert
      self
    end

    def update(updated_fields)
      checked_updated_fields = {}
      updated_fields.each do |key, values|
        s_key = key.to_s
        return unless patchable_fields.include? s_key
        checked_updated_fields[s_key] = values
      end

      @dirty.merge! checked_updated_fields
      patch
    end

    def patch
      @data = response connection.patch path, @dirty
      revert
      self
    end

    def method_missing name_as_symbol, *args, &block
      # allow access to remote data that conflicts with pre-defined methods
      # e.g. write 'zone._zone_id' instead of 'zone.zone_id' to access the remote value of 'zone_id'
      name = name_as_symbol.to_s
      name = name[1..-1] if name.start_with?('_')

      if name.end_with?('=')
        if patchable_fields.include?(name[0..-2])
          @dirty[name[0..-2]] = args[0]
          return
        else
          super(name_as_symbol, args, block)
        end
      end

      # allow access to the original data using 'zone.name!' or 'zone._name!'
      if name.end_with?('!') && data.keys.include?(name[0..-2])
        return data[name[0..2]]
      end

      return @dirty[name] if @dirty.keys.include? name
      return data[name] if data.keys.include? name

      super(name_as_symbol, args, block)
    end

    alias_method :get!, :reload
    alias_method :save, :patch

    private

    def patchable_fields
      %w(paused vanity_name_servers plan)
    end

    def data
      @data ||= get
    end

    def get
      response connection.get path
    end

    def response(response)
      body = response.body

      fail CloudflareError.new body['errors'] unless body['success']

      body['result']
    end

    def path
      "/zones/#{zone_id}"
    end

    def connection
      Connection.new
    end
  end
end
