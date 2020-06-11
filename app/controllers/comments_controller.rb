# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    post.comments.create(comment_params)
    send_new_comment_notification(post)
    redirect_to post_path(post)
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user: current_user)
  end

  def send_new_comment_notification(post)
    CommentNotifierMailer.new_comment(post, current_user).deliver_later
  end
end
