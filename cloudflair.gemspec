# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudflair/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloudflair'
  spec.version       = Cloudflair::VERSION
  spec.authors       = ['Christian Mäder']
  spec.email         = %w(christian.maeder@nine.ch)

  spec.summary       = "Wrapper to CloudFlare's v4 REST API."
  spec.description   = "Cloudflair aims to provide easy access to CloudFlare's public API."
  spec.homepage      = 'https://github.com/ninech/cloudflair'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'faraday', '>= 0.10.0'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'dry-configurable', '~> 0.1'
  spec.add_runtime_dependency 'faraday-detailed_logger'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'dotenv', '~> 2.1'
  spec.add_development_dependency 'rubocop', '~> 0.48'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.15'
end
