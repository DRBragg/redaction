require "faker"

module Redaction
  module Types
    class Html < Base
      include ActionView::Helpers::TagHelper

      TAGS = %i[em strong a]
      private_constant :TAGS

      def content
        1.upto(rand(1..3)).map { content_tag(:p, generate_paragraph.html_safe) }.join("\n")
      end

      private

      def generate_paragraph
        sentences = Faker::Lorem.sentences(number: rand(1..5)).map! do |sentence|
          words = sentence.split(/\s+/)

          words.map! do |word|
            case rand(10)
            when 0, 1, 2
              create_html_word(word)
            else
              word
            end
          end

          words.join(" ")
        end

        sentences.join(" ")
      end

      def create_html_word(word)
        tag = TAGS.sample
        options = tag == :a ? {href: "http://example.com"} : {}

        content_tag(tag, word, options)
      end
    end
  end
end
