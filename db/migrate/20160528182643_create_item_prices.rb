class CreateItemPrices < ActiveRecord::Migration
  def change
    create_table :item_prices do |t|

      t.references :item, index: true, foreign_key: true
      t.references :service_type, index: true, foreign_key: true
      t.integer :service_provider_id
      t.integer :price

      t.timestamps null: false
    end
  end
end
