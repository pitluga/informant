module Informant
  class CheckResult
    attr_reader :status, :output, :timestamp
    attr_accessor :consecutive

    def initialize(status, output, timestamp = Time.now)
      @status = status
      @output = output
      @timestamp = timestamp
      @consecutive = 1
    end

    UNKNOWN = self.new(:unknown, "", nil)
  end
end
