class OrderProductSnapshot < ApplicationRecord
  belongs_to :order
  belongs_to :product_snapshot

  #validate qty positive
end
