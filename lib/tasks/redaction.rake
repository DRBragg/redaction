namespace :redaction do
  desc "Update Models with redacted data"
  task redact: :environment do
    if Rails.env.production?
      abort "Cannot redact in production"
    end

    Rails.application.eager_load!

    model_names = (ENV["MODELS"] || "").split(",").map(&:strip)
    puts model_names.empty? ? "Redacting all models" : "Redacting models: #{model_names.join(", ")}"

    Redaction::Redactor.new(models: model_names).redact
  end
end
