class AddTwoStatusesToStatusTable < ActiveRecord::Migration
  def up
    Status.create(name: 'Logistic Assigned')
    Status.create(name: 'Out for Delivery')
  end
end
