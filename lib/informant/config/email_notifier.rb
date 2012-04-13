module Informant
  module Config
    class EmailNotifier
      attr_reader :from, :name, :to

      def initialize(name, options)
        @name = name
        @from = options[:from]
        @to = options[:to]
      end

      def subscribe
        Informant.channels.notifications.subscribe do |message|
          send_mail(message)
        end
      end

      def send_mail(message)
        if message.command.notifiers.include?(name)
          EmailSender.send_mail(
            @to,
            subject_template(message),
            body_template(message)
          )
        end
      end

      def subject_template(message)
        "#{message.node.name} #{message.command.name} is #{message.new_result.status}"
      end

      def body_template(message)
        email = <<EMAIL
From: #{@from}

Node: #{message.node.name}
Command: #{message.command.name}
Status: #{message.new_result.status}
Was: #{message.old_result.status}

Details:
#{message.new_result.output}

EMAIL
      end
    end
  end
end
