class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :amount
      t.references :order, index: true, foreign_key: true
      t.string :status
      t.string :mode

      t.timestamps null: false
    end
  end
end
