require "redaction/version"
require "redaction/railtie"

module Redaction
  module Types
    autoload :Base, "redaction/types/base"
    autoload :Basic, "redaction/types/basic"
    autoload :BasicHtml, "redaction/types/basic_html"
    autoload :Email, "redaction/types/email"
    autoload :Html, "redaction/types/html"
    autoload :Name, "redaction/types/name"
    autoload :Text, "redaction/types/text"
  end

  autoload :Redactable, "redaction/redactable"
  autoload :Redactor, "redaction/redactor"

  def self.find(redactor_type)
    if redactor_type.respond_to?(:call)
      redactor_type
    else
      "Redaction::Types::#{redactor_type.to_s.camelize}".safe_constantize || Redaction::Types::Base
    end
  end

  def self.redactable_models
    ApplicationRecord.subclasses.select { |descendant| descendant.has_redacted_content? }
  end
end
