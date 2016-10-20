require 'cloudflair/communication'

module Cloudflair
  module Entity
    include Cloudflair::Communication

    def self.included(other_klass)
      other_klass.extend ClassMethods
    end

    module ClassMethods
      def patchable_fields(*fields)
        return @patchable_fields if @patchable_fields

        if fields.nil?
          @patchable_fields = []
        elsif fields.is_a?(Array)
          @patchable_fields = fields.map(&:to_s)
        else
          @patchable_fields = [fields.to_s]
        end
      end

      def deletable(deletable = false)
        return @deletable unless @deletable.nil?

        @deletable = deletable
      end

      def path(path = nil)
        return @path if @path

        fail ArgumentError, 'path is not defined' if path.nil?

        @path = path
      end
    end

    def revert
      dirty.clear
    end

    def reload
      @data = get
      revert
      self
    end

    def patch
      return self if dirty.empty?

      @data = response connection.patch path, dirty
      revert
      self
    end

    def delete
      fail Cloudflair::CloudflairError, "Can't delete unless deletable=true" unless deletable
      return self if @deleted

      @data = response connection.delete path
      @deleted = true
      revert
      self
    end

    def update(updated_fields)
      checked_updated_fields = {}
      updated_fields.each do |key, values|
        s_key = normalize_accessor key

        checked_updated_fields[s_key] = values if patchable_fields.include? s_key
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
          super
        end
      end

      # allow access to the original data using 'zone.always_string!' or 'zone._name!'
      if name.end_with?('!') && data.keys.include?(name[0..-2])
        return data[name[0..2]]
      end

      return dirty[name] if dirty.keys.include? name
      return data[name] if data.keys.include? name

      super
    end

    def respond_to_missing?(name_as_symbol, *args)
      name = normalize_accessor name_as_symbol

      return true if name.end_with?('=') && patchable_fields.include?(name[0..-2])
      return true if name.end_with?('!') && data.keys.include?(name[0..-2])

      return true if dirty.keys.include? name
      return true if data.keys.include? name

      super
    end

    alias get! reload
    alias save patch

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

    def patchable_fields
      self.class.patchable_fields
    end

    def deletable
      self.class.deletable
    end

    def path
      return @path if @path

      path = self.class.path
      interpreted_path = path.clone
      path.scan /:([a-zA-Z_][a-zA-Z0-9_]+[!?=]?)/ do |match, *|
        interpreted_path.gsub! ":#{match}", send(match).to_s
      end
      @path = interpreted_path
    end

    def dirty
      @dirty ||= {}
    end
  end
end
