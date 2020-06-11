# frozen_string_literal: true

class PostsController < ApplicationController
  respond_to :html

  before_action :set_product, only: %i[show new create]
  before_action :set_current_user_post, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def show
    flash.keep
    @post = Post.with_username.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.new
  end

  def create
    post = current_user.posts.new(post_params)
    post.product_id = @product.id
    flash[:success] = 'Post was successfully created.' if post.save
    respond_with post.product, post
  end

  def edit
  end

  def update
    flash[:success] = 'Post was successfully updated.' if @post.update(post_params)
    respond_with @post.product, @post
  end

  def destroy
    flash[:success] = 'Post was successfully destroyed.' if @post.destroy
    respond_with @post.product, @post
  end

  #def followed
  #  @posts = current_user.followed_posts
  #  render :index
  #end

  def liked
    @posts = current_user.liked_posts
    render :index
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_current_user_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :featured_image, :featured_image_cache)
  end
end
