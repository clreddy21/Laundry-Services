class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.references :reviewable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
