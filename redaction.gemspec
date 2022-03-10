require_relative "lib/redaction/version"

Gem::Specification.new do |spec|
  spec.name = "redaction"
  spec.version = Redaction::VERSION
  spec.authors = ["Drew Bragg"]
  spec.email = ["drbragg@hey.com"]
  spec.homepage = "https://github.com/drbragg/redaction"
  spec.summary = "Easily redact your ActiveRecord Models."
  spec.description = "Easily redact your ActiveRecord Models."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/drbragg/redaction/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 5.1.0"
  spec.add_dependency "faker"
  spec.add_dependency "ruby-progressbar"
end
