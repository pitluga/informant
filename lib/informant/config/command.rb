module Informant
  module Config
    class Command
      attr_reader :interval, :execute, :name, :notifiers
      attr_reader :checks_before_notification

      def initialize(name, options)
        @name = name
        @interval = options.fetch(:interval, 60)
        @checks_before_notification = options.fetch(:checks_before_notification, 3)
        @execute = options[:execute]
        @notifiers = options[:notifiers]
      end

      def run_for(node)
        result = CommandRunner.run(execute)
        node.report(self, result)
        message = CheckMessage.new(node, self, result)
        Informant.channels.checks.push(message)
      end
    end
  end
end
