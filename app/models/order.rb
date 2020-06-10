class Order < ApplicationRecord
  belongs_to :user

  has_many :items, class_name: 'OrderProductSnapshot', inverse_of: :order
  has_many :products, through: :items, source: :product_snapshot

  def from_cart(cart)
    cart.each do |product_id, quantity|
      product = Product.find(product_id)
      items.create(
        product_snapshot: product.snapshot,
        quantity: quantity
      )
    end
  end
end
