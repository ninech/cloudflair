# Cloudflair

[![Build Status](https://travis-ci.org/ninech/cloudflair.svg?branch=master)](https://travis-ci.org/ninech/cloudflair)
[![Gem Version](https://badge.fury.io/rb/cloudflair.svg)](https://badge.fury.io/rb/cloudflair)

A simple Ruby-wrapper around Cloudflare's v4 API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudflair'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudflair

## A Note on Faraday

We have decided to not tightly control the version of faraday (anymore). The versions of faraday that are known to work are listed below. If you want to update to a newer version, you're doing it at your own risk. (But if it works, which is usually when all specs pass, please send a PR to update the list below.)

To be on the safe side, we recommend to lock `faraday` to any of the versions listed below. This can be done like this:

```ruby
gem 'cloudflair'
gem 'faraday', '>=0.13', '<0.14'
```

### Faraday Versions known to work

* `gem 'faraday', '>= 0.12', '<= 0.13'`
* `gem 'faraday', '>= 0.13', '<= 0.14'` (starting with `gem 'cloudflair', '>= 0.2.0'`)

## Usage

### Configuration

Put this somewhere, where it runs, before any call to anything else of Cloudflair.
If you are using Rails, then this would probably be somewhere beneath `/config`.

```ruby
require 'cloudflair'
Cloudflair.configure do |config|
  config.cloudflare.auth.key = 'YOUR_API_KEY'
  config.cloudflare.auth.email = 'YOUR_ACCOUNT_EMAIL'
  # if you have a user_service_key, you don't need auth.key and auth.email
  config.cloudflare.auth.user_service_key = 'YOUR_USER_SERVICE_KEY'

  # these are optional:
  config.cloudflare.api_base_url = 'https://your_cloudflare_mock.local'
  config.faraday.adapter = :your_preferred_faraday_adapter
  # built-in options: :logger, :detailed_logger; default: nil
  config.faraday.logger = :logger
end
```

### Call An API Endpoint

This gem is organized along the URL schema of Cloudflare (as shown in the examples below). So you're good off to check the original Cloudflare [API documentation](https://api.cloudflare.com) for more information on the URL schema.

```ruby
require 'cloudflair'

# GET https://api.cloudflare.com/client/v4/railguns
Cloudflair.railguns
# => [...]

# GET https://api.cloudflare.com/client/v4/zones
Cloudflair.zones
# => [...]

# GET https://api.cloudflare.com/client/v4/zones/cd7d068de3012345da9420df9514dad0
Cloudflair.zone('023e105f4ecef8ad9ca31a8372d0c353').name
# => "blog.example.com"

# GET https://api.cloudflare.com/client/v4/zones/cd7d068de3012345da9420df9514dad0/settings/development_mode
Cloudflair.zone('023e105f4ecef8ad9ca31a8372d0c353').settings.development_mode.value
# => "on"
# => "off"

# PATCH https://api.cloudflare.com/client/v4/zones/cd7d068de3012345da9420df9514dad0/settings/development_mode
# {"value"="on"}
Cloudflair.zone('023e105f4ecef8ad9ca31a8372d0c353').settings.development_mode.tap do |dm|
  dm.value = 'on'
  dm.save
end

# GET https://api.cloudflare.com/client/v4/zones/023e105f4ecef8ad9ca31a8372d0c353/dns_records/372e67954025e0ba6aaa6d586b9e0b59
Cloudflair.zone('023e105f4ecef8ad9ca31a8372d0c353').dns_record('372e67954025e0ba6aaa6d586b9e0b59').name
# => "examples.com"
```

You can use any field that Cloudflare's API returns. If a field is covered by some internal field, use `_field`. When you set a new value for a field and then want to access original value, you can use `field!` and `_field!`, respectively.

A good reference on how to use this wrapper are also the Rspecs.

## Implemented Endpoints

* `/railguns` GET, POST
* `/railguns/:railgun_id` GET, PATCH, DELETE
* `/railguns/:railgun_id/zones` GET
* `/zones` GET, POST
* `/zones/:zone_id` GET, PATCH, DELETE
* `/zones/:zone_id/analytics/dashboard` GET
* `/zones/:zone_id/analytics/colos` GET
* `/zones/:zone_id/available_plans` GET
* `/zones/:zone_id/available_plans/:plan_id` GET
* `/zones/:zone_id/available_rate_plans`
* `/zones/:zone_id/custom_hostnames` GET, POST, PATCH
* `/zones/:zone_id/dns_records` GET, POST
* `/zones/:zone_id/dns_records/:record_id` GET, DELETE (PUT not implemented)
* `/zones/:zone_id/purge_cache` POST
* `/zones/:zone_id/railguns` GET
* `/zones/:zone_id/railguns/:railgun_id` GET
* `/zones/:zone_id/railguns/:railgun_id/diagnose` GET, PATCH
* `/zones/:zone_id/settings/advanced_ddos` GET
* `/zones/:zone_id/settings/always_online` GET, PATCH
* `/zones/:zone_id/settings/browser_cache_ttl` GET, PATCH
* `/zones/:zone_id/settings/browser_check` GET, PATCH
* `/zones/:zone_id/settings/cache_level` GET, PATCH
* `/zones/:zone_id/settings/challenge_ttl` GET, PATCH
* `/zones/:zone_id/settings/development_mode` GET, PATCH
* `/zones/:zone_id/settings/email_obfuscation` GET, PATCH
* `/zones/:zone_id/settings/hotlink_protection` GET, PATCH
* `/zones/:zone_id/settings/ip_geolocation` GET, PATCH
* `/zones/:zone_id/settings/ipv6` GET, PATCH
* `/zones/:zone_id/settings/minify` GET, PATCH
* `/zones/:zone_id/settings/mirage` GET, PATCH
* `/zones/:zone_id/settings/mobile_redirect` GET, PATCH
* `/zones/:zone_id/settings/origin_error_page_pass_thru` GET, PATCH
* `/zones/:zone_id/settings/polish` GET, PATCH
* `/zones/:zone_id/settings/prefetch_preload` GET, PATCH
* `/zones/:zone_id/settings/response_buffering` GET, PATCH
* `/zones/:zone_id/settings/rocket_loader` GET, PATCH
* `/zones/:zone_id/settings/security_header` GET, PATCH
* `/zones/:zone_id/settings/server_side_exclude` GET, PATCH
* `/zones/:zone_id/settings/server_level` GET, PATCH
* `/zones/:zone_id/settings/sort_query_string_for_cache` GET, PATCH
* `/zones/:zone_id/settings/ssl` GET, PATCH
* `/zones/:zone_id/settings/tls_1_2_only` GET, PATCH
* `/zones/:zone_id/settings/tls_1_3` GET, PATCH
* `/zones/:zone_id/settings/tls_client_auth` GET, PATCH
* `/zones/:zone_id/settings/true_client_ip_header` GET, PATCH
* `/zones/:zone_id/settings/waf` GET, PATCH
* `/zones/:zone_id/settings/websockets` GET, PATCH

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Developing Guidelines

* The number one aim of this API wrapper is to mimic the Cloudflare API as it is laid out in the URL. So if the url is `/zones/:zone_id/analytics/dashboard`, then the corresponding Ruby code should become `Cloudflair.zones('abcdefg').analytics.dashboard`.
* The API should load resources only when required to. So `Cloudflair.zones('abcdefg')` alone would not call out to Cloudflare, but only when `Cloudflair.zones('abcdefg').name` is called. Likewise, `Cloudflair.zones` will immediately call Cloudflare, as it requires the result immediately. (Unless we begin to introduce a kind of 'delayed Array'. Yet we probably don't want that.)
* Adding additional wrappers for the API shall be easy and done in only a few minutes. (Most of the `/zones/:zone_id/settings/*` API calls were implemented in about five minutes.) So the cloudflair internal API should hide the complexity away. (E.g. the complexity of the fetching, parsing, error handling, etc. should be hidden away. See `Connection`, `Communication` and `Entity`, which contain almost all of the complexity of this Gem.)
* Please write Rspecs for each new API endpoint. Use the JSON provided in the official Cloudflare API documentation as test data.

## Contributing

Bug reports and pull requests are welcome on GitHub at [ninech/cloudflair](https://github.com/ninech/cloudflair).

### Whishlist

* Full API support
* Metrics reporting
* Rate Limit Tracking

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About

This gem is currently maintained and funded by [nine](https://nine.ch).

[![logo of the company 'nine'](https://logo.apps.at-nine.ch/Dmqied_eSaoBMQwk3vVgn4UIgDo=/trim/500x0/logo_claim.png)](https://www.nine.ch)
