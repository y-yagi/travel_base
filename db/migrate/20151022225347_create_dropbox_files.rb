class CreateDropboxFiles < ActiveRecord::Migration
  def change
    create_table :dropbox_files do |t|
      t.string :name
      t.string :url
      t.references :travel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
