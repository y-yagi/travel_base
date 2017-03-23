require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TravelBase
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    # For not swallow errors in after_commit/after_rollback callbacks.
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    config.middleware.use(ExceptionNotification::Rack,
      config_for(:exception_notification).with_indifferent_access)

    config.generators do |g|
      g.assets     false
      g.helper     false
    end

    config.active_record.time_zone_aware_types = [:time]
    config.middleware.delete Rack::Sendfile

    config.load_defaults "5.1"
  end
end
