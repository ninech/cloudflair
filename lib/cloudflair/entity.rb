# frozen_string_literal: true

require 'cloudflair/communication'

module Cloudflair
  module Entity
    include Cloudflair::Communication

    def self.included(other_klass)
      other_klass.extend ClassMethods
    end

    module ClassMethods
      def self.extended(other_klass)
        @other_klass = other_klass
      end

      def patchable_fields(*fields)
        return @patchable_fields if @patchable_fields

        @patchable_fields = if fields.nil?
                              []
                            elsif fields.is_a?(Array)
                              fields.map(&:to_s)
                            else
                              [fields.to_s]
                            end
      end

      def deletable(deletable = false)
        return @deletable unless @deletable.nil?

        @deletable = deletable
      end

      def path(path = nil)
        return @path if @path

        raise ArgumentError, 'path is not defined' if path.nil?

        @path = path
      end

      def object_fields(*fields)
        return @object_fields if @object_fields

        @object_fields = if fields.nil? || fields.empty?
                           []
                         else
                           fields.map(&:to_s)
                         end
      end

      # allowed values:
      # <code>
      # array_object_fields :field_a, :field_b, :field_c, 'fieldname_as_string'
      # # next is ame as previous
      # array_object_fields field_a: nil, field_b: nil, field_c: nil, 'fieldname_as_string': nil
      # # next defines the types of the objects
      # array_object_fields field_a: Klass, field_b: proc { |data| Klass.new data }, field_c: nil, 'fieldname_as_string'
      # </code>
      def array_object_fields(*fields_to_class_map)
        return @array_object_fields if @array_object_fields

        if fields_to_class_map.nil? || fields_to_class_map.empty?
          @array_object_fields = {}
        else
          fields_map = turn_all_items_into_a_single_hash(fields_to_class_map)
          @array_object_fields = fields_map
        end
      end

      def turn_all_items_into_a_single_hash(fields_to_class_map)
        fields_map = {}
        fields_to_class_map.each do |field_definition|
          if field_definition.is_a?(Hash)
            fields_to_class_map[0].each do |field, klass_or_proc|
              fields_map[field.to_s] = klass_or_proc
            end
          else
            fields_map[field_definition.to_s] = nil
          end
        end
        fields_map
      end
    end

    def revert
      dirty_data.clear
    end

    def reload
      @data = get
      revert
      self
    end

    def patch
      return self if dirty_data.empty?

      @data = response connection.patch path, dirty_data
      revert
      self
    end

    def delete
      raise Cloudflair::CloudflairError, "Can't delete unless deletable=true" unless deletable
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

      dirty_data.merge! checked_updated_fields
      patch
    end

    def method_missing(name_as_symbol, *args, &block)
      name = normalize_accessor name_as_symbol

      return data if name_as_symbol == :_raw_data!

      if name.end_with?('=')
        if patchable_fields.include?(name[0..-2])
          dirty_data[name[0..-2]] = args[0]
          return
        else
          super
        end
      end

      # allow access to the unmodified data using 'zone.always_string!' or 'zone._name!'
      return data[name[0..2]] if name.end_with?('!') && data.key?(name[0..-2])

      return objectify(name) if object_fields.include? name
      return arrayify(name, array_object_fields[name]) if array_object_fields.key?(name)

      return dirty_data[name] if dirty_data.key?(name)
      return data[name] if data.is_a?(Hash) && data.key?(name)

      super
    end

    def respond_to_missing?(name_as_symbol, *args)
      name = normalize_accessor name_as_symbol

      return true if name_as_symbol == :_raw_data!

      return true if name.end_with?('=') && patchable_fields.include?(name[0..-2])
      return true if name.end_with?('!') && data.key?(name[0..-2])

      return true if object_fields.include? name
      return true if array_object_fields.key?(name)

      return true if dirty_data.key?(name)
      return true if data.is_a?(Hash) && data.key?(name)

      super
    end

    ##
    # :internal: Used to pre-populate an entity
    def data=(data)
      @data = data
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

    def object_fields
      self.class.object_fields
    end

    def array_object_fields
      self.class.array_object_fields
    end

    def objectify(name)
      hash_to_object data[name]
    end

    def arrayify(name, klass_or_proc = nil)
      data[name].map do |data|
        if klass_or_proc.nil?
          hash_to_object data
        elsif klass_or_proc.is_a? Proc
          klass_or_proc.call data
        else
          klass_or_proc.new data
        end
      end
    end

    def path
      return @path if @path

      @path = replace_path_variables_in self.class.path
    end

    def replace_path_variables_in(path)
      interpreted_path = path.clone
      path.scan(/:([a-zA-Z_][a-zA-Z0-9_]+[!?=]?)/) do |match, *|
        interpreted_path.gsub! ":#{match}", send(match).to_s
      end
      interpreted_path
    end

    def dirty_data
      @dirty_data ||= {}
    end
  end
end
