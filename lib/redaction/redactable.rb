module Redaction
  module Redactable
    extend ActiveSupport::Concern

    included do
      class_attribute :redacted_attributes, instance_writer: false

      def redact!
        redacted_attributes.each_pair do |redactor_type, attributes|
          redactor = Redaction.find(redactor_type)

          attributes.each do |attribute|
            if send(attribute).present?
              send("#{attribute}=", redactor.redact)
            end
          end
        end

        save(validate: false)
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
