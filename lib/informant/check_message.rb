module Informant
  class CheckMessage
    attr_reader :node, :command, :result

    def initialize(node, command, result)
      @node = node
      @command = command
      @result = result
    end
  end
end
