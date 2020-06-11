# frozen_string_literal: true

module PostsHelper
  HEADLINE_SIZE = 40

  def headline(post)
    post.content.truncate(HEADLINE_SIZE)
  end
end
