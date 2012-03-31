require 'spec_helper'

describe Informant::CommandRunner do
  describe ".run" do
    run_in_reactor

    it "returns :success for a command that returns 0" do
      check = Informant::CommandRunner.run(PASSING_CHECK)

      check.status.should == :success
      check.output.should == "OK all is well\n"
      check.timestamp.to_i.should be_within(10).of(Time.now.to_i)
    end

    it "returns :failed for a command that returns 1" do
      check = Informant::CommandRunner.run(FAILING_CHECK)

      check.status.should == :failed
      check.output.should == "OH NO! something went wrong\n"
      check.timestamp.to_i.should be_within(10).of(Time.now.to_i)
    end

    it "returns :unknown for a command the returns something else" do
      check = Informant::CommandRunner.run(UNKNOWN_CHECK)

      check.status.should == :unknown
      check.output.should == "Huh? what happened\n"
      check.timestamp.to_i.should be_within(10).of(Time.now.to_i)
    end
  end
end
