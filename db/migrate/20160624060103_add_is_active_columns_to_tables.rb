class AddIsActiveColumnsToTables < ActiveRecord::Migration
  def change
    add_column :items, :is_active, :boolean, default: true
    add_column :service_types, :is_active, :boolean, default: true
    add_column :orders, :status_id, :integer, default: 1
    remove_column :orders, :status
  end
end
