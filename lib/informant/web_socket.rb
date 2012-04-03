module Informant
  class WebSocket
    include Helpers

    def self.start(host = "0.0.0.0", port = 4000)
      EventMachine::WebSocket.start(:host => host, :port => port) do |ws|
        websocket = Informant::WebSocket.new(ws)
        websocket.wire_channels
      end
    end

    def initialize(websocket)
      @websocket = websocket
      @broadcast_channel = EventMachine::Channel.new
    end

    def relay_checks(check)
      @broadcast_channel.push(<<-JSON)
      {
         "id": "#{id_for_status(check)}",
         "commandName": "#{check.command.name}",
         "nodeName": "#{check.node.name}",
         "timestamp": "#{http_date(check.result.timestamp)}",
         "output": "#{check.result.output.chomp}",
         "status": "#{check.result.status}",
         "statusClass": "#{label_class_for_status(check.result.status)}"
      }
      JSON
    end

    def broadcast_checks(check_json)
      @websocket.send(check_json)
    end

    def wire_channels
      Informant.channels.checks.subscribe &method(:relay_checks)
      @broadcast_channel.subscribe &method(:broadcast_checks)
    end
  end
end
