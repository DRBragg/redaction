require "faker"

module Redaction
  module Types
    class BasicHtml
      def redact
        [nil, "em", "strong"].shuffle.map! do |tag|
          text = Faker::Lorem.sentence(word_count: rand(1..3)).sub(/\.$/, "")
          tag ? "<#{tag}>#{text}</#{tag}>" : text
        end.join(" ")
      end
    end
  end
end
