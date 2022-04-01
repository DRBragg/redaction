module Redaction
  module Redactable
    extend ActiveSupport::Concern

    included do
      class_attribute :redacted_attributes, instance_writer: false

      after_commit do
        @_redacting = false
      end

      def redact!
        @_redacting = true
        redacted_attributes.each_pair do |redactor_type, attributes|
          redactor = Redaction.find(redactor_type)

          attributes.each do |attribute|
            if send(attribute).present?
              send("#{attribute}=", redactor.call(self, {attribute: attribute}))
            end
          end
        end

        save!(validate: false, touch: false, context: :redaction)
      end

      def redacting?
        !!@_redacting
      end
    end

    class_methods do
      def redacts(*attributes, with: :basic)
        self.redacted_attributes ||= Hash.new { |hash, key| hash[key] = [] }

        self.redacted_attributes[with] += attributes
      end

      def has_redacted_content?
        self.redacted_attributes&.any?
      end
    end
  end
end
