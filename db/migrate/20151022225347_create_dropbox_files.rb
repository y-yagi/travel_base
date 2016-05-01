class CreateDropboxFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :dropbox_files do |t|
      t.string :name
      t.string :url
      t.references :travel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
