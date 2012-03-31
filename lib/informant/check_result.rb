module Informant
  class CheckResult
    attr_reader :status, :output

    def initialize(status, output)
      @status = status
      @output = output
    end

    UNKNOWN = self.new(:unknown, "")
  end
end
