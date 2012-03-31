module Informant
  class Web < Sinatra::Base
    register Sinatra::Synchrony
    set :erb, :layout => :"layout.html"

    configure :development do
      register Sinatra::Reloader
    end

    get "/" do
      erb :"index.html"
    end

  end
end
