module Informant
  class CheckStatus

    def initialize(node)
      @node = node
      @old_result = Informant::CheckResult::UNKNOWN
      @new_result = Informant::CheckResult::UNKNOWN
      @notified = false
      @first_result = true
      @consecutive = 0
    end

    def report(command, result)
      _assign_new_result(result)
      _do_not_notify_initial_success(result)
      if _should_notify?(command)
        _notify(command)
      end
      @first_result = false
    end

    def status
      @new_result.status
    end

    def output
      @new_result.output
    end

    def _assign_new_result(result)
      @old_result = @new_result
      @new_result = result

      if @old_result.status == @new_result.status
        @consecutive += 1
      else
        @notified = false
        @consecutive = 1
      end
    end

    def _do_not_notify_initial_success(result)
      @notified = true if @first_result && result.status == :success
    end

    def _should_notify?(command)
      !@notified &&
        !(@old_result.status == :unknown && @new_result.status == :success) &&
        command.checks_before_notification <= @consecutive
    end

    def _notify(command)
      @notified = true
      message = NotificationMessage.new(@node, command, @old_result, @new_result)
      Informant.channels.notifications.push(message)
    end
  end
end
