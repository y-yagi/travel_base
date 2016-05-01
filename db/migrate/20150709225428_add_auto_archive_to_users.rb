class AddAutoArchiveToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :auto_archive, :boolean, default: false
  end
end
