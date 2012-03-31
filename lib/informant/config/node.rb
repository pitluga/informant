module Informant
  module Config
    class Node
      attr_reader :name, :address, :commands

      def initialize(config, name, options)
        @config = config
        @name = name
        @address = options[:address]
        @commands = options.fetch(:commands, [])
      end

      def schedule
        @commands.each do |command_name|
          command = @config.commands[command_name]
          Informant.scheduler.add_periodic_timer(command.interval) do
            Informant.check_fiber_pool.spawn { command.run_for(self) }
          end
        end
      end

    end
  end
end
