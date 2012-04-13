require 'spec_helper'

describe Informant::Config::Node do
  describe "check counts" do
    before :each do
      @config = Informant::Configuration.new
      @config.node("node", :address => "localhost", :commands => %w(a b c))
      @config.command("a", :execute => "")
      @config.command("b", :execute => "")
      @config.command("c", :execute => "")
      @node = @config.nodes['node']
    end

    describe "#count_unknown" do
      it "returns the number of unknown checks" do
        command = @config.commands['b']
        @node.status_for(command).report(command, Informant::CheckResult.new(:unknown, ""))

        @node.count_unknown.should == 1
      end
    end

    describe "#count_failed" do
      it "returns the number of failed checks" do
        command = @config.commands['a']
        @node.status_for(command).report(command, Informant::CheckResult.new(:failed, ""))
        command = @config.commands['b']
        @node.status_for(command).report(command, Informant::CheckResult.new(:unknown, ""))
        command = @config.commands['c']
        @node.status_for(command).report(command, Informant::CheckResult.new(:failed, ""))

        @node.count_failed.should == 2
      end
    end
  end
end
