require "faker"

module Redaction
  module Types
    class Email < Base
      def content
        Faker::Internet.safe_email
      end
    end
  end
end
