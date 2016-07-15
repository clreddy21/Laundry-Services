class ChangeColumnNameInOrderComment < ActiveRecord::Migration
  def change
    rename_column :order_comments, :comment_by, :comment_by_id
  end
end
