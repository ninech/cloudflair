require 'spec_helper'

describe Cloudflair::CloudflareError do
  let(:cloudflare_errors) do
    [
      { 'code' => 1003, 'message' => 'Invalid or missing zone id.' },
    ]
  end
  let(:subject) { Cloudflair::CloudflareError.new cloudflare_errors }

  it 'serializes the given errors' do
    expect(subject.to_s).to eq '[ "Invalid or missing zone id." (Code: 1003) ]'
  end

  context 'multiple errors' do
    let(:cloudflare_errors) do
      [
        { 'code' => 1003, 'message' => 'Invalid or missing zone id.' },
        { 'code' => 1003, 'message' => 'Invalid or missing zone id.' },
      ]
    end

    it 'serializes the given errors' do
      expect(subject.to_s).
        to eq '[ "Invalid or missing zone id." (Code: 1003), "Invalid or missing zone id." (Code: 1003) ]'
    end
  end
end
