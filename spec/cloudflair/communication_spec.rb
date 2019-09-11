# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe Cloudflair::Communication do
  let(:faraday) { double('Faraday') }
  let(:url) { '/client/v4/tests/42' }
  let(:response) { double('response', body: response_body, status: 200) }

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

  describe 'valid response' do
    let(:result_json) do
      '{"name":"Beat","boolean":true,"number":1,"float_number":1.2,"date":"2014-05-28T18:46:18.764425Z"}'
    end
    let(:response_body) do
      JSON
        .parse(
          '{"success":true,"errors":[],"messages":[],"result":' +
            result_json +
            ',"result_info":{"page":1,"per_page":20,"count":1,"total_count":2000}}'
        )
    end

    it 'parses the response' do
      expect(subject.response(response)).to eq(JSON.parse(result_json))
    end
  end

  describe 'illegal response format' do
    let(:response_body) { JSON.parse '{"name":"This is not the expected JSON structure."}' }

    it 'raises the appropriate exception' do
      expect { subject.response(response) }.to raise_error Cloudflair::CloudflairError
    end
  end

  describe 'error response' do
    let(:response_body) do
      JSON.parse(
        '{"result":null,"success":false,"errors":[{"code":1003,"message":"Invalid or missing zone id."}],"messages":[]}'
      )
    end

    it 'raises the appropriate exception' do
      expect { subject.response(response) }
        .to raise_error(Cloudflair::CloudflareError, '[ "Invalid or missing zone id." (Code: 1003) ]')
    end
  end

  describe 'http status checks' do
    context '304 Not Modified' do
      let(:response) { double('response', status: 304) }

      it 'returns and empty object' do
        expect(subject.response(response)).to be_nil
      end
    end

    context '400 Bad Request' do
      let(:response) { double('response', status: 400) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '401 Unauthorized' do
      let(:response) { double('response', status: 401) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '403 Forbidden' do
      let(:response) { double('response', status: 403) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '429 Too many requests' do
      let(:response) { double('response', status: 429) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '405 Method Not Allowed' do
      let(:response) { double('response', status: 405) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '415 Unsupported Media Type' do
      let(:response) { double('response', status: 415) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '499 Random' do
      let(:response) { double('response', status: 499) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '500 Internal Server Error' do
      let(:response) { double('response', status: 500) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end

    context '600 Undefined Error' do
      let(:response) { double('response', status: 600) }

      it 'returns and empty object' do
        expect { subject.response response }.to raise_error Cloudflair::CloudflairError
      end
    end
  end
end
