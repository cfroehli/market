class ProductSnapshot < ApplicationRecord
  belongs_to :product

  has_many :order_product_snapshot
  has_many :orders, through: :order_product_snapshot
end
