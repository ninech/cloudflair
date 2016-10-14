# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudflair/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudflair"
  spec.version       = Cloudflair::VERSION
  spec.authors       = ["Christian Mäder"]
  spec.email         = ["cma@nine.ch"]

  spec.summary       = %q{Wrapper to CloudFlare's v4 REST API.}
  spec.description   = %q{Cloudflair aims to provide easy access to CloudFlares public API.}
  spec.homepage      = "https://github.com/ninech/cloudflair"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", ["~> 0.8.11"]
  spec.add_runtime_dependency "dry-configurable", ["~> 0.1.7"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.44.1"
end
