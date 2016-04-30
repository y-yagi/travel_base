class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :detail
      t.references :user, foreign_key: true, index: true
      t.references :place, foreign_key: true, index: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
