# Cloudflair

[![Build Status](https://travis-ci.org/ninech/cloudflair.svg?branch=master)](https://travis-ci.org/ninech/cloudflair)

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

```ruby
require "cloudflair"
Cloudflair.configure do |config|
  config.cloudflare.auth.key = 'YOUR_API_KEY'
  config.cloudflare.auth.email = 'YOUR_ACCOUNT_EMAIL'
  # if you have a user_service_key, you don't need auth.key and auth.email
  config.cloudflare.auth.user_service_key = 'YOUR_USER_SERVICE_KEY'

  # these are optional:
  config.cloudflare.api_base_url = 'https://your_cloudflare_mock.local'
  config.faraday.adapter = :your_preferred_faraday_adapter
end
```

TODO: Write usage instructions here

Along the lines of `Cloudflair.new_connection.zone('zone_id').some_action`

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
