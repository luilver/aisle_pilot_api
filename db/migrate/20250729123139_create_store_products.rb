class CreateStoreProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :store_products do |t|
      t.references :store, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :aisle
      t.json :location
      t.decimal :price

      t.timestamps
    end
  end
end
