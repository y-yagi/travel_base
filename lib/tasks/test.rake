if defined?(Rails.env) && (Rails.env.development? || Rails.env.test?)
  namespace :test do
    task all: %w[test test:system]
  end
end
