require 'cloudflair/communication'

module Cloudflair
  class PurgeCache
    attr_reader :zone_id

    include Cloudflair::Communication

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def purge_all_files(purge_everything=false)
      response connection.delete path, purge_everything: purge_everything
    end

    ##
    # @param [Hash] cache_identifier Consists of :files and :tags, which are String Arrays themselves. Sample: <code>{files: ['https://foo.bar/index.htmll'], tags: ['css','js']}
    def purge(cache_identifier = {})

    end

    def connection
      Connection.new
    end
  end
end
