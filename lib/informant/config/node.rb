module Informant
  module Config
    class Node
      attr_reader :name, :address, :commands, :command_status

      def initialize(config, name, options)
        @config = config
        @name = name
        @address = options[:address]
        @commands = options.fetch(:commands, [])
        @command_status = {}
        @command_status.default = CheckResult::UNKNOWN
      end

      def schedule
        @commands.each do |command_name|
          command = @config.commands[command_name]
          Informant.scheduler.add_periodic_timer(command.interval) do
            Informant.check_fiber_pool.spawn { command.run_for(self) }
          end
        end
      end

      def report(command, new_result)
        old_result = command_status[command.name]
        command_status[command.name] = new_result
        if new_result.status == :failed && old_result.status != new_result.status
          Informant.channels.notifications.push(
            Informant::NotificationMessage.new(self, command, old_result, new_result)
          )
        end
      end

      def count_unknown
        commands.select { |n| command_status[n].status == :unknown }.size
      end

      def count_failed
        commands.select { |n| command_status[n].status == :failed }.size
      end
    end
  end
end
