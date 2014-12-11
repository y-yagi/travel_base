class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.text :memo
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :travel_date_id, null: false
      t.integer :place_id, null: false

      t.timestamps null: false
    end
    add_index :schedules, :travel_date_id
  end
end
