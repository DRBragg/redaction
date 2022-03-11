require "faker"

module Redaction
  module Types
    class Name
      def redact
        Faker::Name.first_name
      end
    end
  end
end
