module Redaction
  module Types
    class Base
      def self.call(*args)
        content
      end

      def self.content
        "[REDACTED]"
      end
    end
  end
end
