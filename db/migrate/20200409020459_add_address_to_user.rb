# frozen_string_literal: true

class AddAddressToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name, null: false
      t.string :address, null: false
    end
  end
end
