class CreateItemPrices < ActiveRecord::Migration
  def change
    create_table :item_prices do |t|
      t.references :service_provider, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.references :service_type, index: true, foreign_key: true
      t.integer :price

      t.timestamps null: false
    end
  end
end
