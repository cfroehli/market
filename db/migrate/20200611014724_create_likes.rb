class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    change_table :users, bulk: true do |t|
      t.integer :likes_count, default: 0
    end

    change_table :posts do |t|
      t.integer :likes_count, default: 0
    end
  end
end
