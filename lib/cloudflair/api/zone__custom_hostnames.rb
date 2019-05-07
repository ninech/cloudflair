require 'cloudflair/api/zone/custom_hostname'

module Cloudflair
  class Zone
    def custom_hostnames(filter = {})
      raw_hostnames = response connection.get("#{path}/custom_hostnames", filter)

      raw_hostnames.map { |raw_hostname| build_custom_hostname(raw_hostname) }
    end

    def custom_hostname(custom_hostname_id)
      Cloudflair::CustomHostname.new zone_id, custom_hostname_id
    end

    def new_custom_hostname(hostname_data)
      raw_hostname = response connection.post("#{path}/custom_hostnames", hostname_data)

      build_custom_hostname raw_hostname
    end

    private

    def build_custom_hostname(raw_hostname)
      hostname = custom_hostname raw_hostname['id']
      hostname.data = raw_hostname
      hostname
    end
  end
end
