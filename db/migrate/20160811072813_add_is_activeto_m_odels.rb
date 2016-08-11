class AddIsActivetoMOdels < ActiveRecord::Migration
  def change
    add_column :order_items, :is_active, :boolean, default: true
    add_column :orders, :is_active, :boolean, default: true
  end
end
