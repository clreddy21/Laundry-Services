class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :order, index: true, foreign_key: true
      t.date :date
      t.time :from_time
      t.time :to_time

      t.timestamps null: false
    end
  end
end
