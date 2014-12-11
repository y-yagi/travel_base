class CreatePhotoServiceUserInfos < ActiveRecord::Migration
  def change
    create_table :photo_service_user_infos do |t|
      t.references :user, index: true
      t.integer :service_type, null: false
      t.string :photo_service_user_id, null: false

      t.timestamps null: false
    end
  end
end
