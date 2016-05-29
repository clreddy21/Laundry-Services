class CreateOrderComments < ActiveRecord::Migration
  def change
    create_table :order_comments do |t|
      t.references :order, index: true, foreign_key: true
      t.text :body
      t.string :comment_by_type
      t.integer :comment_by

      t.timestamps null: false
    end
  end
end
