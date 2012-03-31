module Informant
  module Config
    class Node
      attr_reader :name

      def initialize(name, options)
        @name = name
      end
    end
  end
end
