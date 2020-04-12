class ProductsController < ApplicationController
  respond_to :html

  def index
    @cart = cart_from_session
  end

  def show
    @product = find_product
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    flash[:success] = 'Product was successfully created.' if @product.save
    respond_with @product
  end

  def edit
    @product = find_product
    authorize @product
  end

  def update
    @product = find_product
    authorize @product
    flash[:success] = 'Post was successfully updated.' if @product.update(product_params)
    respond_with @product
  end

  private
  def find_product
    Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Product not found [#{params[:id]}]."
    redirect_to :index
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :photo, :photo_cache, :order)
  end

  #TODO: extract to tools
  def cart_from_session
    session[:cart] ||= {}
  end
end
