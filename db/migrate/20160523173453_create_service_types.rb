class CreateServiceTypes < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.references :user, index: true, foreign_key: true
      t.boolean :wash
      t.boolean :iron
      t.boolean :wash_iron
      t.boolean :dry_cleaning

      t.timestamps null: false
    end
  end
end
