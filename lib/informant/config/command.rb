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
        @last_checked_at = Time.at(0)
      end

      def run_for(node)
        result = CommandRunner.run(execute)
        message = CheckMessage.new(node, self, result)
        Informant.channels.checks.push(message)
        _mark_checked
      end

      def stale?
        Time.now > _next_check
      end

      def _mark_checked(at = Time.now)
        @last_checked_at = at
      end

      def _next_check
        @last_checked_at + interval
      end
    end
  end
end
