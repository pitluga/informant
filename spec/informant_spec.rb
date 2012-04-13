require 'spec_helper'

describe Informant do
  describe ".subscribe" do
    with_stub_channels
    with_config_file(INFORMANTFILE)

    it "subscribes the notifiers to their channels" do
      Informant.subscribe
      Informant.channels.notifications.subscribers.size.should == 1
    end

    it "subscribes the check reporter to the checks channel" do
      Informant.subscribe
      Informant.channels.checks.subscribers.size.should == 1
    end
  end
end
