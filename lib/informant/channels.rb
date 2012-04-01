module Informant
  class Channels
    attr_reader :checks, :notifications

    def self.create
      self.new(EventMachine::Channel.new, EventMachine::Channel.new)
    end

    def initialize(checks, notifications)
      @checks = checks
      @notifications = notifications
    end
  end
end
