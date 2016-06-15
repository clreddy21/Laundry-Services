class AddOrderItemIdToOrderComment < ActiveRecord::Migration
  def change
    add_column :order_comments, :order_item_id, :integer
  end
end
