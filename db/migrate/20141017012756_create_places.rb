class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.text :memo
      t.float :latitude
      t.float :longitude
      t.string :urls, array: :true
      t.datetime :deleted_at
      t.integer :user_id, null: false
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :places, [:deleted_at, :user_id, :status]
  end
end
