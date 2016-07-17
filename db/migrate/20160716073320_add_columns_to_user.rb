class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :experience, :integer
    add_column :users, :shop_name, :string
    add_column :users, :open_time, :time
    add_column :users, :close_time, :time
    add_column :users, :is_open_on_sunday, :boolean
    add_column :users, :capacity, :integer
    add_column :users, :max_workload, :integer
    add_column :users, :is_partner, :boolean
  end
end
