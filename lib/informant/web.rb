module Informant
  class Web < Sinatra::Base
    set :erb, :layout => :"layout.html"

    get "/" do
      erb :"index.html"
    end

  end
end
