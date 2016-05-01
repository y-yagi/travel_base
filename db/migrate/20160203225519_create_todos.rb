class CreateTodos < ActiveRecord::Migration[4.2]
  def change
    create_table :todos do |t|
      t.references :travel, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :detail
      t.datetime :deadline_at
      t.boolean :finished, default: false

      t.timestamps null: false
    end
  end
end
