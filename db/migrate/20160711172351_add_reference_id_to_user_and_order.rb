class AddReferenceIdToUserAndOrder < ActiveRecord::Migration
  def change
    add_column :users, :reference_id, :integer
    add_column :orders, :reference_id, :integer
  end
end
