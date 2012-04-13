require 'spec_helper'

describe Informant::Configuration do
  describe ".configure" do
    with_config_file INFORMANTFILE

    before :each do
      @config = Informant.configuration
    end

    it "builds nodes" do
      @config.nodes.size.should == 30
      name, node = @config.nodes.first
      name.should == "app01"
      node.group.should == "production"
      node.address.should == "127.0.0.1"
      node.commands.should == [
        @config.commands["passing"],
        @config.commands["failing"],
        @config.commands["unknown"],
        @config.commands["flapping"]
      ]
    end

    it "builds commands" do
      @config.commands.size.should == 4
      name, command = @config.commands.first
      name.should == "passing"
      command.interval.should == 10
      File.expand_path(command.execute).should == PASSING_CHECK
    end

    it "builds email notifiers" do
      @config.email_notifiers.size.should == 1
      name, emailer = @config.email_notifiers.first
      name.should == "me"
      emailer.from.should == "informant@example.com"
      emailer.to.should == ["informanttester@gmail.com"]
    end
  end
end
