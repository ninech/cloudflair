# Cloudflair

[![Build Status](https://travis-ci.org/ninech/cloudflair.svg?branch=master)](https://travis-ci.org/ninech/cloudflair)
[![Gem Version](https://badge.fury.io/rb/cloudflair.svg)](https://badge.fury.io/rb/cloudflair)

**UNDER CONSTRUCTION**

A simple Ruby-wrapper around CloudFlare's v4 API.

![Animation of Homer Simpson using of a rescue flare.](https://media.giphy.com/media/n8A8omwp1mVAA/giphy.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudflair'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudflair

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

This gem is organized along the URL schema of CloudFlare.

```ruby
require 'cloudflair'

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
```

You can use any field that Cloudflare's API returns. If a field is covered by some internal field, use `_field`. 

A good reference are also the specs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [ninech/cloudflair](https://github.com/ninech/cloudflair).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Roadmap

* Pull Zone Information
* Zone Name to Zone ID Lookup
* Developer Mode, Cache Purge, Selective Cache Purge
* Airbrake error reporting
* Full API support
* Metrics reporting
* Rate Limit Tracking
* (Global) Rate Limit Tracking (redis?)

## About

This gem is currently maintained and funded by [nine.ch](https://nine.ch).

[![nine.ch Logo](https://blog.nine.ch/assets/logo.png)](https://nine.ch)

We run your Linux server infrastructure – without interruptions, around the clock.
