module Informant
  class Web < Sinatra::Base
    register Sinatra::Synchrony
    set :erb, :layout => :"layout.html"

    get "/" do
      erb :"index.html"
    end

  end
end
