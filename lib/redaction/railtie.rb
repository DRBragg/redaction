module Redaction
  class << self
    def config
      @config ||= Railtie.config.redaction
    end
  end

  class Railtie < ::Rails::Railtie
    config.redaction = ActiveSupport::OrderedOptions.new

    initializer "redaction.initialize" do
      options = config.redaction

      options.email_domain = options.email_domain
      options.progress_bar = options.key?(:progress_bar) ? options.progress_bar : true

      ActiveSupport.on_load(:active_record) do
        include Redaction::Redactable
      end
    end

    rake_tasks do
      load "tasks/redaction.rake"
    end
  end
end
