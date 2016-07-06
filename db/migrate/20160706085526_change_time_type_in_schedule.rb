class ChangeTimeTypeInSchedule < ActiveRecord::Migration
  def change
	  change_column :schedules, :from_time, :datetime
  end
end
