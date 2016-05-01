class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :users, [:deleted_at, :uid, :provider]
  end
end
