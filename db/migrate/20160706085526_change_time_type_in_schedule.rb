class ChangeTimeTypeInSchedule < ActiveRecord::Migration
  def change
    remove_column :schedules, :from_time
    add_column :schedules, :from_time, :datetime
  end
end
