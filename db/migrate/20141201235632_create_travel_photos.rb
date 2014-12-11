class CreateTravelPhotos < ActiveRecord::Migration
  def change
    create_table :travel_photos do |t|
      t.string :name, null: false
      t.references :travel, index: true
      t.references :photo_service_user_info, index: true
      t.string :photo_service_album_id

      t.timestamps null: false
    end
    add_foreign_key :travel_photos, :travels
    add_foreign_key :travel_photos, :photo_service_user_infos
  end
end
