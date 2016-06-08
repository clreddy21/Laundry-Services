class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :customer, index: true, foreign_key: true
      t.references :service_provider, index: true, foreign_key: true
      t.references :logistic, index: true, foreign_key: true
      t.float :total_cost
      t.float :change_in_cost
      t.string :change_in_cost_reason
      t.string :status
      t.string :comment, default: ""

      t.timestamps null: false
    end
  end
end
