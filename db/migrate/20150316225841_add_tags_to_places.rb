class AddTagsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :tags, :string, array: true
    add_index(:places, :tags, using: 'gin')
  end
end
