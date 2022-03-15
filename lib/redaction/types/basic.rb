require "faker"

module Redaction
  module Types
    class Basic < Base
      def self.content
        Faker::Lorem.sentence(word_count: rand(3..10)).gsub(/\.$/, "")
      end
    end
  end
end
