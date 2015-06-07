if Rails.env.development? || Rails.env.test?
  logger = ActiveSupport::Logger.new(File.join(Rails.root, "log", "notifications.log"))
  Rails.backtrace_cleaner.add_silencer { |line| line !~ /^(app|lib)/ }

  ActiveSupport::Notifications.subscribe('instantiation.active_record') do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    if event.duration.to_f > 10
      trace = Rails.backtrace_cleaner.clean(caller).join("\n")
      logger.info("[#{event.name}] time: #{event.duration.to_f}ms  data: #{event.payload.inspect} trace: \n#{trace}\n")
    end
  end

  ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    if event.duration.to_f > 10
      trace = Rails.backtrace_cleaner.clean(caller).join("\n")
      logger.info("[#{event.name}] time: #{event.duration.to_f}ms  data: #{event.payload.inspect} trace: \n#{trace}\n")
    end
  end

  # subscribe all notifications
  # ActiveSupport::Notifications.subscribe(nil) do |*args|
  #   event = ActiveSupport::Notifications::Event.new(*args)
  #   if event.duration.to_f > 1000
  #     trace = Rails.backtrace_cleaner.clean(caller).join("\n")
  #     logger.info("[#{event.name}] time: #{event.duration.to_f}ms  data: #{event.payload.inspect} trace: \n#{trace}\n")
  #   end
  # end
end
