# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fastlane/plugin/mobileiron/version"

Gem::Specification.new do |spec|
  spec.name          = "fastlane-plugin-mobileiron"
  spec.version       = Fastlane::Mobileiron::VERSION
  spec.authors       = ['Roman Ivannikov']
  spec.email         = ['ivannikov.rv@google.com']

  spec.summary       = 'Release your builds to Mobileiron In-Hause instance. https://www.mobileiron.com'
  spec.homepage      = "https://github.com/RIvannikov/fastlane-plugin-mobileiron"
  spec.licenses       = ['MIT']
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE.txt)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency("faraday", ">= 1.0.0")
  spec.add_dependency('faraday_middleware')

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.127.1')
end
