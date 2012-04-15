module Informant
  class CheckStatus
    extend Forwardable

    attr_reader :node, :command

    def_delegators :@new_result, :status, :output, :timestamp
    def_delegators :@new_result, :failed?, :never_checked?, :success?, :unknown?

    def initialize(node, command)
      @node = node
      @command = command
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

    def reschedule!
      @forced_stale = true
    end

    def stale?
      return true if @new_result.never_checked?
      return true if @forced_stale
      @new_result.timestamp < (Time.now - @command.interval)
    end

    def _assign_new_result(result)
      @old_result = @new_result
      @new_result = result
      @forced_stale = false

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
