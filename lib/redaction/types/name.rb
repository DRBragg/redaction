require "faker"

module Redaction
  module Types
    class Name < Base
      def content
        Faker::Name.first_name
      end
    end
  end
end
