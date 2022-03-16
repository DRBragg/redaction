module Redaction
  module Types
    class Base
      attr_reader :record, :data

      def self.call(record, data)
        new(record, data).content
      end

      def initialize(record, data)
        @record = record
        @data = data
      end

      def content
        "[REDACTED]"
      end
    end
  end
end
