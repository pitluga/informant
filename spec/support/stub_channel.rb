class StubChannel
  attr_reader :messages

  def push(message)
    @messages ||= []
    @messages << message
  end

end
