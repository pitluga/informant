module Informant
  module Config
    class Command
      attr_reader :interval, :execute

      def initialize(name, options)
        @name = name
        @interval = options.fetch(:interval, 60)
        @execute = options[:execute]
      end

      def run_for(node)
        result = CommandRunner.run(execute)
        message = CheckMessage.new(node, self, result)
        Informant.channels.checks.push(message)
      end
    end
  end
end
