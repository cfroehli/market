# frozen_string_literal: true

class LikesController < ApplicationController
  respond_to :html

  before_action :set_liked_post
  before_action :forbid_own_post

  def create
    current_user.likes.create(post: @liked_post)
    flash[:success] = 'Thank you !'
    respond_with @liked_post.product, @liked_post
  end

  private

  def set_liked_post
    @liked_post = Post.find(params[:id])
  end

  def forbid_own_post
    return unless current_user == @liked_post.user

    flash[:warning] = "You're not allowed to increment the like counter yourself !"
    respond_with @liked_post.product, @liked_post
  end
end
