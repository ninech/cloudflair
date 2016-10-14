# Cloudflair

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cloudflair`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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
  config.auth.key = 'YOUR_API_KEY'
  config.auth.email = 'YOUR_ACCOUNT_EMAIL'
  # if you have a user_service_key, you don't need auth.key and auth.email
  config.auth.user_service_key = 'YOUR_USER_SERVICE_KEY'

  # these are optional:
  config.api_base_url = 'https://your_cloudflare_mock.local'
end
```

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cloudflair.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Roadmap

* Developer Mode, Cache Purge, Selective Cache Purge
* Airbrake error reporting
* Full API support
* Metrics reporting
* Rate Limit Tracking
* (Global) Rate Limit Tracking (redis?)
