require "faker"

module Redaction
  module Types
    class Email
      def redact
        Faker::Internet.safe_email
      end
    end
  end
end
