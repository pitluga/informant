module Informant
  class Configuration
    attr_reader :nodes, :commands, :email_notifiers

    def self.configure(file = "Informantfile")
      configuration = self.new
      configuration.read_file(file)
      configuration
    end

    def read_file(file)
      Logger.log "Reading configuration file: #{file}"
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

    def email_notifier(name, options)
      @email_notifiers ||= {}
      @email_notifiers[name] = Config::EmailNotifier.new(name, options)
    end
  end
end
