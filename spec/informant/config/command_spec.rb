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

    it "updates the current state of the node" do
      node = @config.nodes['node']
      command = @config.commands['check_passing']
      command.run_for(node)

      node.command_status['check_passing'].status.should == :success
    end
  end
end
