class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.references :messageable, polymorphic: true, index: true
      t.references :user
      t.timestamps null: false
    end
  end
end
