class CreateStatusDates < ActiveRecord::Migration
  def change
    create_table :status_dates do |t|
      t.integer :status_id
      t.string :status_name
      t.references :order, index: true, foreign_key: true
      t.date :date

      t.timestamps null: false
    end
  end
end
