class ChangeTimesInSchedules < ActiveRecord::Migration
  def change
    change_column :schedules, :start_time,  :time
    change_column :schedules, :end_time,    :time
  end
end
