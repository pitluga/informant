require 'spec_helper'

describe Informant::Config::EmailNotifier do
  describe "#subscribe" do
    with_stub_channels

    before(:each) do
      config = Informant::Configuration.new
      config.email_notifier("test", :from => "foo@example.com", :to => ["bar@example.com"])
      @emailer = config.email_notifiers['test']
    end

    it "subscribes to the checks channel" do
      Informant.channels.notifications.subscribers.should be_empty
      @emailer.subscribe
      Informant.channels.notifications.subscribers.size.should == 1
    end
  end

  describe "#send_mail" do
    before(:each) do
      @config = Informant::Configuration.new
      @config.command("passing", :execute => PASSING_CHECK, :notifiers => ["test"])
      @config.command("important", :execute => PASSING_CHECK, :notifiers => ["bob"])
      @config.node("local", :address => "localhost")
      @config.email_notifier("test", :from => "foo@example.com", :to => ["bar@example.com"])
      @config.email_notifier("bob", :from => "foo@example.com", :to => ["bar@example.com"])
    end

    it "sends mail if message is for this notifier" do
      emailer = @config.email_notifiers['test']
      message = Informant::NotificationMessage.new(
        @config.nodes['local'],
        @config.commands['passing'],
        Informant::CheckResult::UNKNOWN,
        Informant::CheckResult.new(:failed, "uh oh")
      )
      Informant::EmailSender.should_receive(:send_mail)
      emailer.send_mail(message)
    end

    it "sends mail if message is for this notifier" do
      emailer = @config.email_notifiers['test']
      message = Informant::NotificationMessage.new(
        @config.nodes['local'],
        @config.commands['important'],
        Informant::CheckResult::UNKNOWN,
        Informant::CheckResult.new(:failed, "uh oh")
      )
      Informant::EmailSender.should_not_receive(:send_mail)
      emailer.send_mail(message)
    end
  end
end
