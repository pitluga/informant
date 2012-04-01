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
          EmailSender.send_mail
        end
      end
    end
  end
end
