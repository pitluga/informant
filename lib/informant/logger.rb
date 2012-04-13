module Informant
  class Logger
    class << self
      attr_accessor :stream
    end

    self.stream = STDOUT

    def self.log(message)
      stream.puts "#{message}"
    end
  end
end
