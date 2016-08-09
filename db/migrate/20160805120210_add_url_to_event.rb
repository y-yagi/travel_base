class AddUrlToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :url, :string
  end
end
