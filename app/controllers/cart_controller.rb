class CartController < ApplicationController
  TAX_RATE = 0.08
  PACKAGING_FEES_LADDER = [
    [100000, 1000],
    [30000,  600],
    [10000,  400],
    [0, 300],
  ].freeze

  def index
    cart = cart_from_session
    if cart.empty?
      flash[:success] = 'Your cart is empty. Choose some product first.'
      redirect_to root_path && return
    end
    @cart_sign = cart_current_sign
  end

  def add_product
    product = find_product
    product_id = product.id.to_s
    cart = cart_from_session
    cart[product_id] = (cart[product_id] || 0) + 1
    @added_product = [product.name, cart[product_id]]
    mark_cart_updated
  end

  def remove_product
    product = find_product
    product_id = product.id.to_s
    cart = cart_from_session
    quantity = (cart[product_id] || 0) - 1
    cart[product_id] = quantity
    cart.delete product_id if quantity <= 0
    @remaining_product = [product.name, 0]
    mark_cart_updated
  end

  def checkout
    if params[:cart_sign] != cart_current_sign
      flash[:danger] = 'Cart content was updated in the meanwhile. Please reconfirm with current content.'
      redirect_to cart_index_path && return
    end

    # TODO: register order content, send delivery notification ...
    clear_cart
    flash[:success] = 'Your order was registered and will be processed soon.'
    redirect_to root_path
  end

  def content
    cart = cart_from_session
    cart_value = 0
    cart_size = 0
    cart_products = Product.find(cart.keys.map { |key| key.to_s.to_i }.to_a)
    @content = cart_products.map do |product|
      product_id = product.id
      price = product.price
      quantity = cart[product_id.to_s]
      cart_value += quantity * price
      cart_size += quantity
      { id: product_id, name: product.name, qty: quantity, price: price }
    end
    packaging_fees = compute_packaging_fees cart_value
    shipping_fees = compute_shipping_fees cart_size
    total = cart_value + packaging_fees + shipping_fees
    total_tax_included = total + (total * TAX_RATE).floor
    @content += [
      { name: 'Packaging fees',   qty: nil, price: packaging_fees     },
      { name: 'Shipping fees',    qty: nil, price: shipping_fees      },
      { name: 'Total (tax inc.)', qty: nil, price: total_tax_included },
    ]
  end

  private

  def find_product
    Product.find(params[:id])
  end

  # TODO: extract to tools
  def cart_from_session
    session[:cart] ||= {}
  end

  def mark_cart_updated
    session[:cart_updated] = DateTime.now
  end

  def cart_current_sign
    Digest::MD5.hexdigest(session[:cart_updated].to_s)
  end

  def clear_cart
    session[:cart] = {}
    session.delete :cart_updated
  end

  def compute_packaging_fees(cart_value)
    PACKAGING_FEES_LADDER.find { |fees| fees[0] <= cart_value }[1]
  end

  def compute_shipping_fees(cart_size)
    ((cart_size / 5) + 1) * 600 # cost = 600 per batch of 5 articles
  end
end
