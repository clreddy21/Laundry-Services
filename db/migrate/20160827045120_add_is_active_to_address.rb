class AddIsActiveToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :is_active, :boolean, default: true
  end
end
