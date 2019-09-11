# frozen_string_literal: true

require 'cloudflair/api/zone/dns_record'

module Cloudflair
  class Zone
    def dns_records(filter = {})
      raw_records = response connection.get("#{path}/dns_records", filter)
      raw_records.map { |raw_record| build_dns_record(raw_record) }
    end

    def dns_record(record_id)
      Cloudflair::DnsRecord.new zone_id, record_id
    end

    def new_dns_record(record_data)
      raw_record = response connection.post("#{path}/dns_records", record_data)
      build_dns_record raw_record
    end

    private

    def build_dns_record(raw_record)
      record = dns_record raw_record['id']
      record.data = raw_record
      record
    end
  end
end
