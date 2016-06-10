class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :addressable_type
      t.integer :addressable_id

      t.timestamps null: false
    end
  end
end
