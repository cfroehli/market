class CreateOrderProductSnapshots < ActiveRecord::Migration[6.0]
  def change
    create_table :order_product_snapshots, id: false do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product_snapshot, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
