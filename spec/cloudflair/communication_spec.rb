require 'spec_helper'
require 'json'

describe Cloudflair::Communication do
  let(:faraday) { double('Faraday') }
  let(:url) { '/client/v4/tests/42' }
  let(:response) { double('response', body: response_body) }

  let(:subject) { Victim.new }
  class Victim
    include Cloudflair::Communication
  end

  describe 'get connection' do
    it 'returns a valid connection' do
      expect(Cloudflair::Connection).to receive(:new).and_return faraday

      expect(subject.connection).to be faraday
    end

    it "does not cache it's connection" do
      expect(Cloudflair::Connection).to receive(:new).twice.and_return faraday

      expect(subject.connection).to be faraday
      expect(subject.connection).to be faraday
    end
  end

  context 'valid response' do
    let(:result_json) do
      '{"name":"Beat","boolean":true,"number":1,"float_number":1.2,"date":"2014-05-28T18:46:18.764425Z"}'
    end
    let(:response_body) do
      JSON.
        parse (
                '{"success":true,"errors":[],"messages":[],"result":' +
                  result_json +
                  ',"result_info":{"page":1,"per_page":20,"count":1,"total_count":2000}}'
              )
    end

    it 'parses the response' do
      expect(subject.response(response)).
        to eq(JSON.parse result_json)
    end
  end

  context 'illegal response format' do
    let(:response_body) { JSON.parse '{"name":"This is not the expected JSON structure."}' }

    it 'raises the appropriate exception' do
      expect { subject.response(response) }.to raise_error Cloudflair::CloudflairError
    end
  end

  context 'error response' do
    let(:response_body) do
      JSON.
        parse('{"result":null,"success":false,"errors":[{"code":1003,"message":"Invalid or missing zone id."}],"messages":[]}')
    end

    it 'raises the appropriate exception' do
      expect { subject.response(response) }.to raise_error Cloudflair::CloudflareError
    end
  end
end
