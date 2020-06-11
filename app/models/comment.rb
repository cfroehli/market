# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  def self.with_username
    joins(:user).select('comments.*, users.username as user_name')
  end
end
