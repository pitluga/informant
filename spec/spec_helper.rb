require 'rspec'
require 'informant'

PASSING_CHECK = File.expand_path("../support/checks/passing_check", __FILE__)
FAILING_CHECK = File.expand_path("../support/checks/failing_check", __FILE__)
UNKNOWN_CHECK = File.expand_path("../support/checks/unknown_check", __FILE__)

def run_in_reactor
  around do |spec|
    EventMachine.run do
      fiber = Fiber.new { spec.run }
      fiber.resume
      EventMachine.stop
    end
  end
end
