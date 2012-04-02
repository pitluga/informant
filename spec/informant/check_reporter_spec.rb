require 'spec_helper'

describe Informant::CheckReporter do
  describe "#subscribe" do
    with_stub_channels

    it "subscribes to the checks channel" do
      Informant.channels.checks.subscribers.size.should == 0
      reporter = Informant::CheckReporter.new
      reporter.subscribe
      Informant.channels.checks.subscribers.size.should == 1
    end
  end

  describe "#on_check" do
    it "delegates the reporting to the node" do
      node = double
      node.should_receive(:report).with(:command, :result)
      message = Informant::CheckMessage.new(node, :command, :result)
      reporter = Informant::CheckReporter.new

      reporter.on_check(message)
    end
  end
end
