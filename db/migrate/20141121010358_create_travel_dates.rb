class CreateTravelDates < ActiveRecord::Migration
  def change
    create_table :travel_dates do |t|
      t.date :date, null: false
      t.integer :travel_id, null: false

      t.timestamps null: false
    end
    add_index :travel_dates, :travel_id
  end
end
