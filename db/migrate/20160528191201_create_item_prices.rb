class CreateItemPrices < ActiveRecord::Migration
  def change
    create_table :item_prices do |t|
      t.references :user, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.float :iron
      t.float :wash
      t.float :wash_iron
      t.float :dry_cleaning

      t.timestamps null: false
    end
  end
end
