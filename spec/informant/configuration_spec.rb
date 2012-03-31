require 'spec_helper'

describe Informant::Configuration do
  describe ".configure" do
    before :each do
      @config = Informant::Configuration.configure(File.expand_path("../../../Informantfile", __FILE__))
    end

    it "builds nodes" do
      @config.nodes.size.should == 1
    end

    it "builds commands" do
      @config.commands.size.should == 1
    end
  end

end
