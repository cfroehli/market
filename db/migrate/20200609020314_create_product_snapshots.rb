class CreateProductSnapshots < ActiveRecord::Migration[6.0]
  def change
    create_table :product_snapshots do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
