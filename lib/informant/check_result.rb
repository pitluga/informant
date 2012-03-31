module Informant
  class CheckResult
    attr_reader :status, :output, :timestamp

    def initialize(status, output, timestamp = Time.now)
      @status = status
      @output = output
      @timestamp = timestamp
    end

    UNKNOWN = self.new(:unknown, "", nil)
  end
end
