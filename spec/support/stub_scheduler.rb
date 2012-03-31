require 'ostruct'

class StubScheduler
  attr_reader :schedules

  def add_periodic_timer(interval, &block)
    @schedules ||= []
    @schedules << OpenStruct.new(:interval => interval, :command => block)
  end
end
