require 'cloudflair/communication'

module Cloudflair
  class PurgeCache
    attr_reader :zone_id

    include Cloudflair::Communication

    def initialize(zone_id)
      @zone_id = zone_id
    end

    ##
    # @param purge_everything must be set to true
    def everything(purge_everything)
      resp = connection.delete(path) { |req| req.body = { purge_everything: purge_everything } }
      response resp
      self
    end

    ##
    # @param [Hash] cache_identifier Consists of :files and :tags, which are String Arrays themselves. Sample: <code>{files: ['https://foo.bar/index.htmll'], tags: ['css','js']}
    def selective(cache_identifier = {})
      return self if cache_identifier.nil? || cache_identifier.empty?

      resp = connection.delete(path) { |req| req.body = cache_identifier }
      response resp
      self
    end

    def path
      "zones/#{zone_id}/purge_cache"
    end
  end
end
