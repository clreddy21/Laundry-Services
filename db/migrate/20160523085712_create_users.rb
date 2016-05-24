class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :mobile
      t.text :jwt
      t.boolean :is_active
      t.string :avatar
      t.integer :reviews_count, :default => 0
      t.float :average_review, :default => 0.0
      t.string :type
      t.string :slug
      t.string :float
      t.string :float
      t.string :gcm_id
      t.string :otp

      t.timestamps null: false
    end
    add_index :users, :slug, unique: true
  end
end
