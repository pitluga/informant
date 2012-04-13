class StubFiberPool
  attr_reader :spawned_blocks

  def initialize
    @spawned_blocks = []
  end

  def spawn(&block)
    @spawned_blocks << block
  end
end
