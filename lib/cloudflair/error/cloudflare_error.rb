module Cloudflair
  class CloudflareError < StandardError
    attr_reader :cloudflare_errors

    def initialize(cloudflare_errors)
      @cloudflare_errors = cloudflare_errors

      super(to_s)
    end

    def to_s
      if cloudflare_errors.empty?
        '[ "An error happened, but no error message/code was given by CloudFlare." (Code: 0000) ]'
      else
        strings = cloudflare_errors.map { |error| "\"#{error['message']}\" (Code: #{error['code']})" }
        "[ #{strings.join ', '} ]"
      end
    end
  end
end
