module Informant
  class CheckReporter
    def subscribe
      Informant.channels.checks.subscribe(&method(:on_check))
    end

    def on_check(message)
      message.node.report(message.command, message.result)
    end
  end
end
