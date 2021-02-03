require "bundler/setup"
require_relative "../lib/fastlane/plugin/mobileiron"
require_relative "../lib/fastlane/plugin/mobileiron/version"
require_relative "../lib/fastlane/plugin/mobileiron/client/mobileiron_api_client"

require 'simplecov'
# SimpleCov.minimum_coverage 95
SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end