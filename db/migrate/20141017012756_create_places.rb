class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.text :memo
      t.float :latitude
      t.float :longitude
      t.string :website
      t.datetime :deleted_at
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :places, :deleted_at
    add_index :places, :user_id
  end
end
