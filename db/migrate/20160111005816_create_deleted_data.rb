class CreateDeletedData < ActiveRecord::Migration
  def change
    create_table :deleted_data do |t|
      t.string :table_name
      t.integer :datum_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :deleted_data, :updated_at
  end
end
