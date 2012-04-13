module Informant
  class Scheduler
    def initialize(fiber_pool)
      @fiber_pool = fiber_pool
    end

    def start_checking!
      EventMachine.add_periodic_timer(1, &method(:check_stale_commands))
    end

    def check_stale_commands
      Informant.configuration.nodes.each do |_, node|
        node.commands.select(&:stale?).each do |command|
          @fiber_pool.spawn { command.run_for(node) }
        end
      end
    end
  end
end
