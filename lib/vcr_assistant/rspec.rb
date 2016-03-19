require 'rspec/core'
require 'vcr_assistant'

RSpec.configure do |config|
  config.include VCRAssistant::TestHelpers
end
