$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'faraday'
require 'faraday_middleware'
require 'cloudflair'
require 'cloudflair/entity'
require 'cloudflair/connection'
require 'cloudflair/communication'
require 'cloudflair/error/cloudflare_error'
require 'cloudflair/error/cloudflair_error'
require 'cloudflair'
require 'cloudflair/api'
require 'cloudflair/api/zone'
require 'cloudflair/api/zone/available_plan'
require 'cloudflair/api/zone/available_rate_plan'
require 'cloudflair/api/zone/purge_cache'
require 'cloudflair/api/zone/settings'
require 'cloudflair/api/zone/settings/advanced_ddos'
require 'cloudflair/api/zone/settings/always_online'
require 'cloudflair/api/zone/settings/browser_cache_ttl'
require 'cloudflair/api/zone/settings/cache_level'
require 'cloudflair/api/zone/settings/challenge_ttl'
require 'cloudflair/api/zone/settings/development_mode'
require 'cloudflair/api/zone/settings/email_obfuscation'
require 'cloudflair/api/zone/settings/hotlink_protection'
require 'cloudflair/api/zone/settings/ip_geolocation'
require 'cloudflair/api/zone/settings/ipv6'
require 'cloudflair/api/zone/settings/minify'
require 'cloudflair/api/zone/settings/mirage'
require 'cloudflair/api/zone/settings/mobile_redirect'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
