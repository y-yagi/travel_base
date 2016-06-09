class AddNotificationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notification, :bool, default: false
  end
end
