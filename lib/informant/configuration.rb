module Informant
  class Configuration
    attr_reader :nodes, :commands, :notifications

    def self.configure(file = "Informantfile")
      configuration = self.new
      configuration.read_file(file)
      configuration
    end

    def read_file(file)
      content = File.read(file)
      instance_eval(content)
    end

    def node(name, options)
      @nodes ||= {}
      @nodes[name] = Config::Node.new(self, name, options)
    end

    def command(name, options)
      @commands ||= {}
      @commands[name] = Config::Command.new(name, options)
    end

    def notification(name, options)
      @notifications ||= {}
      @notifications[name] = Config::Notification(name, options)
    end
  end
end
