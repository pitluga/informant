module Informant
  module Config
    class Node
      attr_reader :name, :address, :commands, :group

      def initialize(config, name, options)
        @config = config
        @name = name
        @group = options.fetch(:group, "nodes")
        @address = options[:address]
        @commands = options.fetch(:commands, [])
        @command_statuses = {}
      end

      def schedule
        @commands.each do |command_name|
          command = @config.commands[command_name]
          Informant.scheduler.add_periodic_timer(command.interval) do
            Informant.check_fiber_pool.spawn { command.run_for(self) }
          end
        end
      end

      def status_for(command)
        @command_statuses[command.name] ||= Informant::CheckStatus.new(self, command)
      end

      def statuses
        @commands.map { |command_name| status_for(Informant.configuration.commands[command_name]) }
      end

      def report(command, new_result)
        status_for(command).report(command, new_result)
      end

      def count_unknown
        @command_statuses.values.select(&:unknown?).size
      end

      def count_failed
        @command_statuses.values.select(&:failed?).size
      end
    end
  end
end
