module Informant
  class CheckStatus

    def initialize(node)
      @node = node
      @old_result = Informant::CheckResult::NEVER_CHECKED
      @new_result = Informant::CheckResult::NEVER_CHECKED
      @notified = false
      @consecutive = 0
    end

    def report(command, result)
      _assign_new_result(result)
      _do_not_notify_initial_success
      if _should_notify?(command)
        _notify(command)
      end
    end

    def status
      @new_result.status
    end

    def output
      @new_result.output
    end

    def timestamp
      @new_result.timestamp
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

    def _do_not_notify_initial_success
      @notified = true if @old_result.never_checked? && @new_result.success?
    end

    def _should_notify?(command)
      !@notified && command.checks_before_notification <= @consecutive
    end

    def _notify(command)
      @notified = true
      message = NotificationMessage.new(@node, command, @old_result, @new_result)
      Informant.channels.notifications.push(message)
    end
  end
end
