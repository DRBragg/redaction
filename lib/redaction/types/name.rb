require "faker"

module Redaction
  module Types
    class Name < Base
      def self.content
        Faker::Name.first_name
      end
    end
  end
end
