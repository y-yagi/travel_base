class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.text :memo
      t.datetime :start_time
      t.datetime :end_time
      t.integer :travel_date_id
      t.integer :place_id

      t.timestamps null: false
    end
  end
end
