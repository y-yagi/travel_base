namespace :notification do
  desc "send notification"
  task send: :environment do
    Notification.new.send
  end
end
