class CreateRoutes < ActiveRecord::Migration[4.2]
  def change
    create_table :routes do |t|
      t.text :detail

      t.timestamps null: false
    end
  end
end
