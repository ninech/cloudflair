module Cloudflair
  module FaradayHelper
    def faraday_stubs
      Faraday::Adapter::Test::Stubs.new
    end
    def faraday
      Faraday.new do |faraday|
        faraday.adapter :test, faraday_stubs
        faraday.request :url_encoded
        faraday.response :json, content_type: /\bjson$/
      end
    end
  end
end
