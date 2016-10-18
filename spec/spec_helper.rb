$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'faraday'
require 'faraday_middleware'
require 'cloudflair'
require 'cloudflair/zone'
require 'cloudflair/zone/development_mode'
require 'cloudflair/connection'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

