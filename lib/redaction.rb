require "redaction/version"
require "redaction/railtie"

module Redaction
  module Types
    autoload :BasicHtml, "redaction/types/basic_html"
    autoload :Basic, "redaction/types/basic"
    autoload :Email, "redaction/types/email"
    autoload :Html, "redaction/types/html"
    autoload :Text, "redaction/types/text"
  end

  autoload :Redactable, "redaction/redactable"
  autoload :Redactor, "redaction/redactor"

  def self.find(redactor_type)
    "Redaction::Types::#{redactor_type.to_s.camelize}".constantize.new
  end

  def self.redactable_models
    ApplicationRecord.subclasses.select { |descendant| descendant.has_redacted_content? }
  end
end
