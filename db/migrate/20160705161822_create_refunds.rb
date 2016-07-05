class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.references :user, index: true, foreign_key: true
      t.float :amount
      t.boolean :status
      t.string :remarks

      t.timestamps null: false
    end
  end
end
