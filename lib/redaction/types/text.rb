require "faker"

module Redaction
  module Types
    class Text
      def redact
        paragraphs = 1.upto(rand(1..3)).map do
          Faker::Lorem.paragraph(sentence_count: rand(1..5))
        end

        "#{paragraphs.join("\n\n")}\n"
      end
    end
  end
end
