class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :body
      t.boolean :is_read
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
