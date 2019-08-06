# frozen_string_literal: true

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
  class TestSubPoro
    attr_accessor :name

    def initialize(data)
      @name = data['name']
    end
  end
  class TestEntity5
    include Cloudflair::Entity

    attr_accessor :test_id
    path 'tests/:test_id'
    array_object_fields an_object_array: TestSubPoro

    def initialize
      @test_id = 42
    end
  end
  class TestSubEntity
    include Cloudflair::Entity

    attr_accessor :my_id
    path 'tests/:my_id/sub'

    def initialize(my_id, data = nil)
      @my_id = my_id
      self.data = data
    end
  end
  class TestEntity6
    include Cloudflair::Entity

    attr_accessor :test_id
    path 'tests/:test_id'
    array_object_fields an_object_array: proc { |data| TestSubEntity.new(@test_id, data) }

    def initialize
      @test_id = 42
    end
  end

  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter :test, faraday_stubs
    end
  end
  let(:response_json) do
    result_json = <<-json
      {
        "name": "Beat",
        "boolean": true,
        "number": 1,
        "float_number": 1.2,
        "date": "2014-05-28T18:46:18.764425Z",
        "an_object": {
          "key": "value",
          "second": 2
        },
        "an_array": [],
        "an_object_array": [{
          "name": "obj1"
        }, {
          "name": "obj2"
        }, {
          "name": "obj3"
        }]
      }
    json

    '{"success":true,"errors":[],"messages":[],"result":' +
      result_json +
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

  describe 'objectification of the content of array fields' do
    context 'anonymous classes' do
      it 'does not return `an_object_array` as Hashes' do
        expect(subject.an_object_array).to be_a Array
        subject.an_object_array.each do |obj|
          expect(obj).not_to be_a Hash
        end
      end

      it 'returns the correct values' do
        arr = subject.an_object_array

        expect(arr[0].name).to eq 'obj1'
        expect(arr[1].name).to eq 'obj2'
        expect(arr[2].name).to eq 'obj3'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject._name).to eq 'Beat'
        expect(subject.an_object_array).not_to be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object_array
        b = subject.an_object_array

        expect(a).not_to be b
        expect(b).not_to be a
      end
    end

    context 'poro classes' do
      let(:subject) { TestEntity5.new }

      it 'does not return `an_object_array` as Hashes' do
        expect(subject.an_object_array).to be_a Array
        subject.an_object_array.each do |obj|
          expect(obj).to be_a TestSubPoro
        end
      end

      it 'returns the correct values' do
        arr = subject.an_object_array

        expect(arr[0].name).to eq 'obj1'
        expect(arr[1].name).to eq 'obj2'
        expect(arr[2].name).to eq 'obj3'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject._name).to eq 'Beat'
        expect(subject.an_object_array).not_to be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object_array
        b = subject.an_object_array

        expect(a).not_to be b
        expect(b).not_to be a
      end
    end

    context 'entity classes' do
      let(:subject) { TestEntity6.new }

      it 'does not return `an_object_array` as Hashes' do
        expect(subject.an_object_array).to be_a Array
        subject.an_object_array.each do |obj|
          expect(obj).to be_a TestSubEntity
        end
      end

      it 'returns the correct values' do
        arr = subject.an_object_array

        expect(arr[0].name).to eq 'obj1'
        expect(arr[1].name).to eq 'obj2'
        expect(arr[2].name).to eq 'obj3'
      end

      it 'does not call the server for the sub-object' do
        expect(faraday).to receive(:get).once.and_call_original

        expect(subject._name).to eq 'Beat'
        expect(subject.an_object_array).not_to be_a Hash
      end

      it 'is a new object everytime' do
        a = subject.an_object_array
        b = subject.an_object_array

        expect(a).not_to be b
        expect(b).not_to be a
      end
    end
  end
end
