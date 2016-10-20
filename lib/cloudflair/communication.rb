require 'cloudflair/error/cloudflare_error'
require 'cloudflair/error/cloudflair_error'
require 'cloudflair/connection'

module Cloudflair
  module Communication
    def response(response)
      body = response.body

      unless body['success']
        fail Cloudflair::CloudflairError, "Unrecognized response format: '#{body}'" unless body['errors']
        fail Cloudflair::CloudflareError, body['errors']
      end

      body['result']
    end

    def connection
      Cloudflair::Connection.new
    end
  end
end
