module Informant
  module Config
    class Node
      attr_reader :name, :address, :group

      def initialize(config, name, options)
        @config = config
        @name = name
        @group = options.fetch(:group, "nodes")
        @address = options[:address]
        @command_names = options.fetch(:commands, [])
        @command_statuses = {}
      end

      def commands
        @command_names.map { |name| Informant.configuration.commands[name] }
      end

      def stale_commands
        statuses.select(&:stale?).map(&:command)
      end

      def status_for(command)
        @command_statuses[command.name] ||= Informant::CheckStatus.new(self, command)
      end

      def statuses
        @command_names.map { |command_name| status_for(Informant.configuration.commands[command_name]) }
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
