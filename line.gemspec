# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'line/version'

Gem::Specification.new do |spec|
  spec.name          = 'line'
  spec.version       = Line::VERSION
  spec.authors       = ['oshjma']
  spec.email         = ['k.oshjma@gmail.com']

  spec.summary       = 'LINE BOT API wrapper'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/oshjma/line'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.0'
end
