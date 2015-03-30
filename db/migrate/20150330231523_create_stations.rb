class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :line
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
