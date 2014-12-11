class CreateTravelMembers < ActiveRecord::Migration
  def change
    create_table :travel_members do |t|
      t.references :travel, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :travel_members, :travels
    add_foreign_key :travel_members, :users
  end
end
