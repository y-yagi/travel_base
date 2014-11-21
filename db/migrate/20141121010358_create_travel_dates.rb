class CreateTravelDates < ActiveRecord::Migration
  def change
    create_table :travel_dates do |t|
      t.date :date
      t.integer :travel_id

      t.timestamps null: false
    end
    add_index :travel_dates, :travel_id
  end
end
