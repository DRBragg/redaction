class CustomRedactor < Redaction::Types::Base
  def self.content
    "I'm a custom redactor"
  end
end