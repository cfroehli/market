# frozen_string_literal: true

class ProductsController < ApplicationController
  respond_to :html

  before_action :set_product, only: %i[show edit update]

  def index
    @cart = cart_from_session
  end

  def show
  end

  def new
    authorize :product
    @product = Product.new
  end

  def create
    authorize :product
    @product = Product.new(product_params)
    flash[:success] = 'Product was successfully created.' if @product.save
    respond_with @product
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    flash[:success] = 'Product was successfully updated.' if @product.update(product_params)
    respond_with @product
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :photo, :photo_cache, :order)
  end

  # TODO: extract to tools
  def cart_from_session
    session[:cart] ||= {}
  end
end
