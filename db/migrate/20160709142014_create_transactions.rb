class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.float :amount
      t.string :type
      t.string :mode
      t.string :remarks
      t.float :balance

      t.timestamps null: false
    end
  end
end
