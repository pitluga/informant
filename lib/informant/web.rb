module Informant
  class Web < Sinatra::Base
    register Sinatra::Synchrony
    set :erb, :layout => :"layout.html"
    helpers Informant::Helpers

    configure :development do
      register Sinatra::Reloader
    end

    get "/" do
      @active_tab = :nodes
      @grouped_nodes = Informant.configuration.nodes.inject({}) do |groups, (name, n)|
        groups[n.group] ||= {}
        groups[n.group][name] = n
        groups
      end
      erb :"index.html"
    end

    post "/:node/:command/reschedule" do
      node = Informant.configuration.nodes[params['node']]
      command = Informant.configuration.commands[params['command']]
      status = node.status_for(command)
      status.reschedule!
    end
  end
end
