class AddServiceProviderChooserToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :service_provider_chooser, :string
  end
end
