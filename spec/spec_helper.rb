$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'faraday'
require 'faraday_middleware'
require 'cloudflair'
require 'cloudflair/connection'
require 'cloudflair/communication'
require 'cloudflair/error/cloudflare_error'
require 'cloudflair/error/cloudflair_error'
require 'cloudflair'
require 'cloudflair/api/zone'
require 'cloudflair/api/zone/settings'
require 'cloudflair/api/zone/settings/development_mode'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
