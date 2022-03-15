require "faker"

module Redaction
  module Types
    class Email < Base
      def self.content
        Faker::Internet.safe_email
      end
    end
  end
end
