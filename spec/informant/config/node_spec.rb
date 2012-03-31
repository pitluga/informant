require 'spec_helper'

describe Informant::Config::Node do

  describe "#schedule" do
    with_stub_scheduler

    before :each do
      @config = Informant::Configuration.new
      @config.command("check_passing", :execute => PASSING_CHECK, :interval => 60)
      @config.command("check_failing", :execute => FAILING_CHECK, :interval => 60)
      @config.command("check_unknown", :execute => UNKNOWN_CHECK, :interval => 60)
      @config.node("node", :address => "localhost", :commands => ["check_passing"])
    end

    it "schedules a command at a given interval" do
      node = @config.nodes["node"]
      node.schedule

      schedule = Informant.scheduler.schedules.first
      schedule.interval.should == 60
      schedule.command.should_not be_nil
    end

    it "schedules multiple commands for a single node" do
      @config.node(
        "multi-commands",
        :address => "localhost",
        :commands => ["check_passing", "check_failing", "check_unknown"]
      )
      node = @config.nodes["multi-commands"]
      node.schedule

      Informant.scheduler.schedules.size.should == 3
    end
  end

  describe "check counts" do
    before :each do
      config = Informant::Configuration.new
      config.node("node", :address => "localhost", :commands => %w(a b c))
      @node = config.nodes['node']
    end

    describe "#count_unknown" do
      it "returns the number of unknown checks" do
        @node.command_status['b'] = Informant::CheckResult.new(:unknown, "")
        @node.command_status['c'] = Informant::CheckResult.new(:success, "")

        @node.count_unknown.should == 2
      end
    end

    describe "#count_failed" do
      it "returns the number of failed checks" do
        @node.command_status['a'] = Informant::CheckResult.new(:failed, "")
        @node.command_status['b'] = Informant::CheckResult.new(:unknown, "")
        @node.command_status['c'] = Informant::CheckResult.new(:failed, "")

        @node.count_failed.should == 2
      end
    end
  end

end
