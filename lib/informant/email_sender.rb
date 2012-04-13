module Informant
  class EmailSender

    # it sucks that this isn't evented.
    def self.send_mail(to, subject, body)
      [to].flatten.each do |send_to|
        puts "sending mail to #{send_to}"
        IO.popen("mail -s #{subject.inspect} #{send_to}", 'w') { |io| io.puts "#{body}\n.\n\n" }
      end
    end
  end
end
