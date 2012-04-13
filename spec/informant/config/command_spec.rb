require 'spec_helper'

describe Informant::Config::Command do
  describe "#run_for" do
    run_in_reactor
    with_stub_channels

    before(:each) do
      @config = Informant::Configuration.new
      @config.command("check_passing", :execute => PASSING_CHECK, :interval => 60)
      @config.node("node", :address => "localhost", :commands => ["check_passing"])
    end

    it "executes the command and broadcasts the results" do
      node = @config.nodes['node']
      command = @config.commands['check_passing']
      command.run_for(node)

      message = Informant.channels.checks.messages.first
      message.node.should == node
      message.command.should == command
      message.result.status.should == :success
    end

    it "marks the command as no longer stale" do
      node = @config.nodes['node']
      command = @config.commands['check_passing']
      command.should be_stale
      command.run_for(node)
      command.should_not be_stale
    end
  end

  describe "#stale?" do
    before(:each) do
      @config = Informant::Configuration.new
      @config.command("check_passing", :execute => PASSING_CHECK, :interval => 60)
    end

    it "returns true if the command has never been run" do
      command = @config.commands["check_passing"]
      command.should be_stale
    end

    it "returns false if the command has been checked within the interval" do
      command = @config.commands["check_passing"]
      command._mark_checked
      command.should_not be_stale
    end

    it "returns ture if the command has not been checked within the time interval" do
      command = @config.commands["check_passing"]
      command._mark_checked(Time.now - 62)
      command.should be_stale
    end
  end
end
