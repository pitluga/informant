class StubChannel
  attr_reader :messages
  attr_reader :subscribers

  def messages
    @messages ||= []
  end

  def push(message)
    messages << message
  end

  def subscribe(&block)
    subscribers << block
  end

  def subscribers
    @subscribers ||= []
  end
end
