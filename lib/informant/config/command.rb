module Informant
  module Config
    class Command
      attr_reader :interval, :execute, :name, :notifiers

      def initialize(name, options)
        @name = name
        @interval = options.fetch(:interval, 60)
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
