class CreateTravels < ActiveRecord::Migration
  def change
    create_table :travels do |t|
      t.string :name
      t.text :memo
      t.date :start_date
      t.date :end_date
      t.datetime :deleted_at
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :travels, [:deleted_at, :user_id]
  end
end
