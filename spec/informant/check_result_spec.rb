require 'spec_helper'

describe Informant::CheckResult do
  describe "#success?" do
    it "is true when status is :success" do
      Informant::CheckResult.new(:success, "Yay").should be_success
      Informant::CheckResult.new(:failed, "Boo").should_not be_success
      Informant::CheckResult.new(:unknown, "Huh").should_not be_success
      Informant::CheckResult.new(:never_checked, "").should_not be_success
    end
  end

  describe "#unknown?" do
    it "is true when status is :unknown" do
      Informant::CheckResult.new(:success, "Yay").should_not be_unknown
      Informant::CheckResult.new(:failed, "Boo").should_not be_unknown
      Informant::CheckResult.new(:unknown, "Huh").should be_unknown
      Informant::CheckResult.new(:never_checked, "").should_not be_unknown
    end
  end

  describe "#failed?" do
    it "is true when status is :failed" do
      Informant::CheckResult.new(:success, "Yay").should_not be_failed
      Informant::CheckResult.new(:failed, "Boo").should be_failed
      Informant::CheckResult.new(:unknown, "Huh").should_not be_failed
      Informant::CheckResult.new(:never_checked, "").should_not be_failed
    end
  end

  describe "#never_checked?" do
    it "is true when status is :failed" do
      Informant::CheckResult.new(:success, "Yay").should_not be_never_checked
      Informant::CheckResult.new(:failed, "Boo").should_not be_never_checked
      Informant::CheckResult.new(:unknown, "Huh").should_not be_never_checked
      Informant::CheckResult.new(:never_checked, "").should be_never_checked
    end
  end
end
