require 'spec_helper'

describe Informant::Helpers do
  before :all do
    klass = Class.new
    klass.send(:include, Informant::Helpers)
    @helper = klass.new
  end

  describe "#label_class_for_status" do
    it "returns label-success for :success" do
      @helper.label_class_for_status(:success).should == "label-success"
    end

    it "returns label-error for :failed" do
      @helper.label_class_for_status(:failed).should == "label-important"
    end

    it "returns label-warning for anything else" do
      @helper.label_class_for_status(:unknown).should == "label-warning"
      @helper.label_class_for_status(nil).should == "label-warning"
    end
  end

  describe "#tab_class" do
    it "returns active if the parameters match" do
      @helper.tab_class(:foo, :foo).should == "active"
    end

    it "returns empty string if the parameters are different" do
      @helper.tab_class(:foo, :bar).should == ""
    end
  end
end
