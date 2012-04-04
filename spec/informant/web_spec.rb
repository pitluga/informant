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
end
