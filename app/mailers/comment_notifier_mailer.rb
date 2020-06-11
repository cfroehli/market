# frozen_string_literal: true

class CommentNotifierMailer < ApplicationMailer
  helper :posts

  def new_comment(post, by_user)
    @post = post
    mail(to: @post.user.email,
         subject: "Post #{post.id} got a new comment by #{by_user.username}.")
  end
end
