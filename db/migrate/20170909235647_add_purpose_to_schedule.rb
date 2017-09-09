class AddPurposeToSchedule < ActiveRecord::Migration[5.1]
  def change
    add_column :schedules, :purpose, :integer
  end
end
