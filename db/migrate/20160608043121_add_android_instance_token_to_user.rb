class AddAndroidInstanceTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :android_instance_token, :string
  end
end
