module Informant
  class CheckResult
    attr_reader :status, :output, :timestamp

    def initialize(status, output, timestamp = Time.now)
      @status = status
      @output = output
      @timestamp = timestamp
    end

    NEVER_CHECKED = CheckResult.new(:never_checked, "", nil)

    def failed?
      @status == :failed
    end

    def never_checked?
      @status == :never_checked
    end

    def success?
      @status == :success
    end

    def unknown?
      @status == :unknown
    end
  end
end
