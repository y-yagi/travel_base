class AddAutoArchiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auto_archive, :boolean, default: false
  end
end
