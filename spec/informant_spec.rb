require 'spec_helper'

describe Informant do
  describe ".schedule" do
    with_stub_scheduler
    with_config_file(INFORMANTFILE)

    it "schedules the checks for all the nodes" do
      Informant.schedule
      Informant.scheduler.schedules.size.should == 3
    end
  end
end
