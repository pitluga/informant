require 'spec_helper'

describe Informant::Scheduler do
  describe "#start_checking!" do
    it "creates a periodic timer that checks every second" do
      scheduler = Informant::Scheduler.new(StubFiberPool.new)
      EventMachine.should_receive(:add_periodic_timer).with(1)

      scheduler.start_checking!
    end
  end

  describe "#check_stale_commands" do
    with_config_file INFORMANTFILE

    it "it schedules each stale command to be run" do
      fiber_pool = StubFiberPool.new
      scheduler = Informant::Scheduler.new(fiber_pool)
      scheduler.check_stale_commands
      fiber_pool.spawned_blocks.size.should == 120
    end
  end
end
