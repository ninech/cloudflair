require 'cloudflair/error/cloudflare_error'
require 'cloudflair/error/cloudflair_error'
require 'cloudflair/connection'

module Cloudflair
  module Communication
    def response(response)
      return nil if response.status == 304

      http_error? response.status

      read response
    end

    def connection
      Cloudflair::Connection.new
    end

    private

    def read(response)
      body = response.body

      unless body['success']
        fail Cloudflair::CloudflairError, "Unrecognized response format: '#{body}'" unless body['errors']
        fail Cloudflair::CloudflareError, body['errors']
      end

      body['result']
    end

    def http_error?(status)
      case status
      when 200..399 then
        return
      when 400 then
        fail Cloudflair::CloudflairError, '400 Bad Request'
      when 401 then
        fail Cloudflair::CloudflairError, '401 Unauthorized'
      when 403 then
        fail Cloudflair::CloudflairError, '403 Forbidden'
      when 429 then
        fail Cloudflair::CloudflairError, '429 Too Many Requests'
      when 405 then
        fail Cloudflair::CloudflairError, '405 Method Not Allowed'
      when 415 then
        fail Cloudflair::CloudflairError, '415 Unsupported Media Type'
      when 400..499 then
        fail Cloudflair::CloudflairError, "#{status} Request Error"
      when 500..599 then
        fail Cloudflair::CloudflairError, "#{status} Remote Error"
      else
        fail Cloudflair::CloudflairError, "#{status} Unknown Error Code"
      end
    end
  end
end
