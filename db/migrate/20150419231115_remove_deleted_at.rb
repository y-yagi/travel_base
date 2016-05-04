class RemoveDeletedAt < ActiveRecord::Migration[4.2]
  def change
    remove_column :places,  :deleted_at, :datetime, index: true
    remove_column :travels, :deleted_at, :datetime, index: true
    remove_column :users,   :deleted_at, :datetime, index: true
  end
end
