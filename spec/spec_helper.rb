ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'informant'

require 'support/stub_channel'
require 'support/stub_scheduler'

PASSING_CHECK = File.expand_path("../support/checks/passing_check", __FILE__)
FAILING_CHECK = File.expand_path("../support/checks/failing_check", __FILE__)
UNKNOWN_CHECK = File.expand_path("../support/checks/unknown_check", __FILE__)
FLAPPING_CHECK = File.expand_path("../support/checks/flapping_check", __FILE__)

INFORMANTFILE = File.expand_path("../../Informantfile", __FILE__)

Sinatra::Synchrony.patch_tests!

RSpec.configure do |config|
  config.expect_with :rspec
end

def run_in_reactor
  around do |spec|
    EventMachine.run do
      fiber = Fiber.new { spec.run }
      fiber.resume
      EventMachine.stop
    end
  end
end

def with_stub_scheduler
  around do |spec|
    scheduler = Informant.scheduler
    Informant.scheduler = StubScheduler.new
    spec.run
    Informant.scheduler = scheduler
  end
end

def with_stub_channels
  around do |spec|
    channels = Informant.channels
    Informant.channels = Informant::Channels.new(StubChannel.new, StubChannel.new)
    spec.run
    Informant.channels = channels
  end
end

def with_config_file(file)
  around do |spec|
    configuration = Informant.configuration
    Informant.configuration = Informant::Configuration.configure(INFORMANTFILE)
    spec.run
    Informant.configuration = configuration
  end
end
