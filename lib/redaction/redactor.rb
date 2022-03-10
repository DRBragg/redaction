require "ruby-progressbar"

module Redaction
  class Redactor
    attr_reader :models_to_redact

    def initialize(models: nil)
      @models_to_redact = set_models(models)
    end

    def redact
      models_to_redact.each do |model|
        next if model.redacted_attributes.empty?

        model_progress = progress_bar(model.name, model.count)

        model.all.unscoped.find_each do |record|
          record.redact!
          model_progress.increment
        end
      end
    end

    private

    def set_models(models)
      if models.present?
        models
          .map { |model| model.constantize }
          .select { |model| model.has_redacted_content? }
      else
        Redaction.redactable_models
      end
    end

    def progress_bar(title, total)
      ProgressBar.create(
        format: "%t %b\u{15E7}%i %p%%",
        progress_mark: " ",
        remainder_mark: "\u{FF65}",
        title: title,
        total: total
      )
    end
  end
end
