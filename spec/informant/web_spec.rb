require 'spec_helper'

describe Informant::Web do
  include Rack::Test::Methods
  with_config_file(INFORMANTFILE)

  def app
    Informant::Web
  end

  describe "GET /" do
    it "returns success" do
      get "/"
      last_response.should be_ok
    end
  end

  describe "POST /:node/:command/reschedule" do
    it "marks the command as stale" do
      node = Informant.configuration.nodes['app01']
      command = Informant.configuration.commands['passing']
      status = node.status_for(command)
      status.report(command, Informant::CheckResult.new(:success, "Great Success"))
      status.should_not be_stale
      post "/app01/passing/reschedule"
      last_response.should be_ok
      status.should be_stale
    end
  end
end
