require 'spec_helper'

describe Informant::Scheduler do
  describe ".add_periodic_timer" do
    it "wraps eventmachine" do
      scheduler = Informant::Scheduler.new
      command = lambda { }
      EventMachine.should_receive(:add_periodic_timer).with(10, &command)

      scheduler.add_periodic_timer(10, &command)
    end
  end
end
