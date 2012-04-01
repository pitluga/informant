module Informant
  class NotificationMessage
    attr_reader :node, :command, :old_result, :new_result

    def initialize(node, command, old_result, new_result)
      @node = node
      @command = command
      @old_result = old_result
      @new_result = new_result
    end
  end
end
