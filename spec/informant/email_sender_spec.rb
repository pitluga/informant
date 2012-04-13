require 'spec_helper'

describe Informant::EmailSender do
  describe ".send_mail" do
    it "sends an email" do
      pending "this should be run manually"
      Informant::EmailSender.send_mail(
        'example@example.com',
        'Test Email',
        'This is a test email'
      )
    end
  end
end
