module Redaction
  class Railtie < ::Rails::Railtie
    initializer "redaction.initialize" do
      ActiveSupport.on_load(:active_record) do
        include Redaction::Redactable
      end
    end

    rake_tasks do
      load "tasks/redaction.rake"
    end
  end
end
