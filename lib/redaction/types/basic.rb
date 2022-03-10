require "faker"

module Redaction
  module Types
    class Basic
      def redact
        Faker::Lorem.sentence(word_count: rand(3..10)).gsub(/\.$/, "")
      end
    end
  end
end
