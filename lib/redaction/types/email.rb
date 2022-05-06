require "faker"

module Redaction
  module Types
    class Email < Base
      def content
        if Redaction.config.email_domain.present?
          Faker::Internet.email(domain: Redaction.config.email_domain)
        else
          Faker::Internet.safe_email
        end
      end
    end
  end
end
