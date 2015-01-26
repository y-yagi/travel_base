class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.text :detail
      t.references :schedule, index: true

      t.timestamps null: false
    end
    add_foreign_key :routes, :schedules
  end
end
