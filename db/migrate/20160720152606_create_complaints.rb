class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.references :order, index: true, foreign_key: true
      t.string :title
      t.string :status
      t.integer :reference_id

      t.timestamps null: false
    end
  end
end
