require "faker"

module Redaction
  module Types
    class Phone < Base
      def content
        # Use cell_phone so no extension is added
        # see: https://github.com/faker-ruby/faker/blob/master/doc/default/phone_number.md
        Faker::PhoneNumber.cell_phone
      end
    end
  end
end
