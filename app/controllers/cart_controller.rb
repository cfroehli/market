# frozen_string_literal: true

class CartController < ApplicationController
  include ::Market::Cart::SessionMixin

  before_action :set_product, only: %i[add_product remove_product]
  before_action :set_cart, only: %i[index add_product remove_product checkout content]
  before_action :verify_cart_signature, only: %i[checkout]

  def index
    if @cart.empty?
      flash[:success] = 'Your cart is empty. Choose some product first.'
      redirect_to root_path
    end
  end

  def add_product
    @added_product = [@product.name, @cart.add(@product.id.to_s)]
  end

  def remove_product
    @remaining_product = [@product.name, @cart.remove(@product.id.to_s)]
  end

  def checkout
    current_user.orders.create.from_cart(@cart)
    @cart.clear
    flash[:success] = 'Your order was registered and will be processed soon.'
    redirect_to root_path
  end

  def content
    pricing = ::Market::Pricer.price(@cart)
    @content = pricing[:detail]
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def verify_cart_signature
    return if params[:cart_sign] == @cart.signature

    flash[:danger] = 'Cart content was updated in the meanwhile. Please reconfirm with current content.'
    redirect_to cart_index_path
  end
end
