class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :service_provider_id
      t.integer :logistic_id
      t.float :total_cost
      t.float :change_in_cost
      t.string :change_in_cost_reason
      t.string :status
      t.string :comment, default: ""

      t.timestamps null: false
    end
  end
end
