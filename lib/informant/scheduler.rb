module Informant
  class Scheduler

    def add_periodic_timer(interval, &block)
      EventMachine.add_periodic_timer(interval, &block)
    end
  end
end
