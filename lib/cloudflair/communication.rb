require 'cloudflair/error/cloudflare_error'
require 'cloudflair/error/cloudflair_error'

module Cloudflair
  module Communication
    def revert
      dirty.clear
    end

    def reload
      @data = get
      revert
      self
    end

    def patch
      @data = response connection.patch path, dirty
      revert
      self
    end

    def update(updated_fields)
      checked_updated_fields = {}
      updated_fields.each do |key, values|
        s_key = normalize_accessor key

        return unless patchable_fields.include? s_key
        checked_updated_fields[s_key] = values
      end

      dirty.merge! checked_updated_fields
      patch
    end

    def method_missing(name_as_symbol, *args, &block)
      name = normalize_accessor name_as_symbol

      if name.end_with?('=')
        if patchable_fields.include?(name[0..-2])
          dirty[name[0..-2]] = args[0]
          return
        else
          super(name_as_symbol, args, block)
        end
      end

      # allow access to the original data using 'zone.always_string!' or 'zone._name!'
      if name.end_with?('!') && data.keys.include?(name[0..-2])
        return data[name[0..2]]
      end

      return dirty[name] if dirty.keys.include? name
      return data[name] if data.keys.include? name

      super(name_as_symbol, args, block)
    end

    alias_method :get!, :reload
    alias_method :save, :patch

    private

    def normalize_accessor(symbol_or_string)
      always_string = symbol_or_string.to_s

      # allows access to remote data who's name conflicts with pre-defined methods
      # e.g. write 'zone._zone_id' instead of 'zone.zone_id' to access the remote value of 'zone_id'
      always_string.start_with?('_') ? always_string[1..-1] : always_string
    end

    def data
      @data ||= get
    end

    def get
      response connection.get path
    end

    def response(response)
      body = response.body

      unless body['success']
        fail Cloudflair::CloudflairError.new "Unrecognized response format: '#{body}'" unless body['errors']
        fail Cloudflair::CloudflareError.new body['errors']
      end

      body['result']
    end

    def dirty
      @dirty ||= {}
    end

    def connection
      Connection.new
    end
  end
end
