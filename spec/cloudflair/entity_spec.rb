require 'spec_helper'

describe Cloudflair::Entity do
  class TestEntity
    include Cloudflair::Entity

    attr_accessor :name

    patchable_fields :name
    deletable true
    path 'tests/:test_id'
    object_fields :an_object
    array_object_fields :an_object_array

    def initialize(name = 'Urs')
      @name = name
    end

    private

    def test_id
      42
    end
  end
  class TestEntity2
    include Cloudflair::Entity

    # no patchable_fields
    # not deletable

    path 'tests/42'
  end
  class TestEntity3
    include Cloudflair::Entity

    # Wrong URL (starts with '/')
    path '/tests/42'
  end
  class TestEntity4
    include Cloudflair::Entity

    # no path defined
  end

  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter :test, faraday_stubs
    end
  end
  let(:raw_data) do
    {
      'name' => 'Beat',
      'boolean' => true,
      'number' => 1,
      'float_number' => 1.2,
      'date' => '2014-05-28T18:46:18.764425Z',
      'an_object' => {
        'key' => 'value',
        'second' => 2,
      },
      'an_array' => [],
      'an_object_array' => [
        { 'name' => 'obj1' },
        { 'name' => 'obj2' },
        { 'name' => 'obj3' },
      ],
    }
  end
  let(:response_json) do
    '{"success":true,"errors":[],"messages":[],"result":' +
      JSON.generate(raw_data) +
      ',"result_info":{"page":1,"per_page":20,"count":1,"total_count":2000}}'
  end
  let(:url) { '/client/v4/tests/42' }
  let(:subject) { TestEntity.new }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'gets the name from the TestEntity' do
    expect(subject.name).to eq 'Urs'
  end

  describe 'fetch values' do
    it 'returns the correct name' do
      expect(subject._name).to eq 'Beat'
    end

    it 'caches the data' do
      expect(faraday).to receive(:get).once.and_call_original

      expect(subject._name).to eq 'Beat'
      expect(subject._name).to eq 'Beat'
    end

    it 'fetches the data when asked to' do
      expect(faraday).to receive(:get).twice.and_call_original
      subject.reload
      subject.reload
    end

    it 'returns itself when reloading' do
      expect(subject.reload).to be subject
    end

    it 'raises a NoMethodError when the field is not in the response' do
      expect { subject.nope }.to raise_error NoMethodError
    end

    it 'returns a number' do
      expect(subject.number).to be 1
    end

    it 'returns a floating-point number' do
      expect(subject.float_number).to be 1.2
    end

    it 'returns an Array' do
      expect(subject.an_array).to be_a Array
      expect(subject.an_array.length).to be 0
    end

    it 'returns the raw data' do
      expect(subject._raw_data!).to eq raw_data
    end
  end

  describe 'send values' do
    before do
      faraday_stubs.patch(url, 'name' => 'Fritz') do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'raises a NoMethodError when the field is not modifiable' do
      expect { subject.nope = false }.to raise_error NoMethodError
    end

    it 'returns the value that has been set' do
      subject.name = 'Fritz'
      subject._name = 'Alfred'
      expect(subject.name).to eq 'Fritz'
      expect(subject._name).to eq 'Alfred'
    end

    it 'sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      subject._name = 'Fritz'
      expect(subject.patch).to be subject
      expect(subject.name).to eq 'Urs'

      # this value is read from the response, which is 'Beat', and not 'Fritz'
      # this also checks implicitly that the @dirty cache has been emptied
      expect(subject._name).to eq 'Beat'
    end

    it 'updates the value and sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      expect(subject.update(name: 'Fritz')).to be subject
      expect(subject.name).to eq 'Urs'

      # this value is read from the response, which is 'Beat', and not 'Fritz'
      # this also checks implicitly that the @dirty cache has been emptied
      expect(subject._name).to eq 'Beat'
    end

    it 'updates only allowed values and sends PATCH to the server' do
      expect(faraday).to receive(:patch).and_call_original

      expect(subject.update(name: 'Fritz', illegal: 'It Is')).to be subject
    end

    it 'does not send PATCH to the server when nothing changed' do
      expect(faraday).to_not receive(:patch)

      expect(subject.patch).to be subject
    end

    it 'does not send PATCH to the server when nothing valid changed' do
      expect(faraday).to_not receive(:patch)

      expect(subject.update(illegal: 'It Is')).to be subject
    end
  end

  describe 'api class has no patchable_fields' do
    let(:subject) { TestEntity2.new }

    it 'still runs a fetch' do
      expect(faraday).to receive(:get).once.and_call_original

      expect(subject.name).to eq 'Beat'
    end

    it 'does not send PATCH' do
      expect(faraday).to_not receive(:patch)

      expect(subject.update(name: 'Fritz')).to be subject
    end

    it 'does not allow setting any value' do
      expect { subject.name = 'Mars' }.to raise_error NoMethodError
    end
  end

  describe 'delete entities' do
    let(:response_json) do
      '{"success":true,"errors":[],"messages":[],"result":{"id":42}}'
    end
    before do
      faraday_stubs.delete(url) do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'deletes the entity from the server' do
      expect(faraday).to receive(:delete).and_call_original

      expect(subject.delete).to be subject
    end

    it 'calls the server only once' do
      expect(faraday).to receive(:delete).once.and_call_original

      expect(subject.delete).to be subject
      expect(subject.delete).to be subject
    end

    it 'parses the response' do
      expect(subject.delete).to be subject
      expect(subject.id).to be 42
      expect { subject._name }.to raise_error NoMethodError
    end

    context 'non-deletable entity' do
      let(:subject) { TestEntity2.new }
      it 'raises an error' do
        expect { subject.delete }.to raise_error Cloudflair::CloudflairError
      end
    end
  end

  describe 'a wrong path is given' do
    let(:subject) { TestEntity3.new }

    it 'raises an exception' do
      expect { subject.name }.to raise_error Faraday::Adapter::Test::Stubs::NotFound
    end
  end

  describe 'no path given' do
    let(:subject) { TestEntity4.new }

    it 'raises an exception' do
      expect { subject.reload }.to raise_error ArgumentError
    end
  end

  describe 'objectification of fields' do
    it 'does not return `an_object` as Hash' do
      expect(subject.an_object).to_not be_a Hash
    end

    it 'returns the correct values' do
      expect(subject.an_object).to_not be_a Hash
      expect(subject.an_object.key).to eq 'value'
      expect(subject.an_object.second).to be 2
    end

    it 'does not call the server for the sub-object' do
      expect(faraday).to receive(:get).once.and_call_original

      expect(subject._name).to eq 'Beat'
      expect(subject.an_object).to_not be_a Hash
    end

    it 'is a new object everytime' do
      a = subject.an_object
      b = subject.an_object

      expect(a).to_not be b
      expect(b).to_not be a
    end
  end
end
