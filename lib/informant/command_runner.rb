module Informant
  class CommandRunner
    def self.run(command)
      output, status = _system(command)

      exit_status = case status.exitstatus
                    when 0 then :success
                    when 1 then :failed
                    else :unknown
                    end

      CheckResult.new(exit_status, output)
    end

    def self._system(command)
      current_fiber = Fiber.current

      EventMachine.system(command) do |output, status|
        current_fiber.resume(output, status)
      end

      return Fiber.yield
    end
  end
end
