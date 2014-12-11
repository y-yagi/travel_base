class CreateTravels < ActiveRecord::Migration
  def change
    create_table :travels do |t|
      t.string :name, null: false
      t.text :memo
      t.date :start_date
      t.date :end_date
      t.datetime :deleted_at
      t.integer :owner_id, null: false

      t.timestamps null: false
    end
    add_index :travels, [:deleted_at, :owner_id]
  end
end
