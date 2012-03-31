module Informant
  class Channels
    attr_reader :checks

    def self.create
      self.new(EventMachine::Channel.new)
    end

    def initialize(checks)
      @checks = checks
    end
  end
end
