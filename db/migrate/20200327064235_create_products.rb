# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 60
      t.integer :price, null: false
      t.string :photo
      t.text :description, null: false, limit: 1024
      t.boolean :enabled, null: false, default: true
      t.integer :order, null: false, default: 0
      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
