module Cloudflair
  class CloudflareError < StandardError
    attr_reader :cloudflare_errors

    def initialize(cloudflare_errors)
      @cloudflare_errors = cloudflare_errors

      super(to_s)
    end

    def to_s
      return '[ "An error happened, but no error message/code was given by CloudFlare." (Code: 0000) ]' if cloudflare_errors.empty?

      strings = cloudflare_errors.map { |cf_e| "\"#{cf_e[:message]}\" (Code: #{cf_e[:code]})" }
      "[ #{strings.join ', '} ]"
    end
  end
end
