class CreateJoinTablePlaceStation < ActiveRecord::Migration[4.2]
  def change
    create_join_table :places, :stations do |t|
      t.index [:place_id, :station_id]
      t.index [:station_id, :place_id]
      t.string :distance
    end
  end
end
