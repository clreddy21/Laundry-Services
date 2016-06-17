class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.references :reviewable, polymorphic: true, index: true
      t.integer :review_by_id
      t.string :body


      t.timestamps null: false
    end
  end
end
