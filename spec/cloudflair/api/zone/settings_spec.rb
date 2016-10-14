require 'cloudflair'

describe Cloudflair do
  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }

  describe '#settings' do
    before do
      @zone = Cloudflair.zone zone_identifier
    end

    it 'returns something' do
      expect(@zone.settings).to_not be_nil
    end

    describe '#development_mode' do
      before do
        @settings = @zone.settings
      end

      it 'returns current setting' do
        expect(@settings.development_mode).to_not be_nil
      end
    end
  end
end
