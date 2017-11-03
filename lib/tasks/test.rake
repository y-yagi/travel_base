if defined?(Rails.env) && (Rails.env.development? || Rails.env.test?)
  namespace :test do
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    task :system_with_coveralls => [:test, :system, 'coveralls:push']
  end
end
