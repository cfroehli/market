# frozen_string_literal: true

class Like < ApplicationRecord
  self.primary_keys = :user_id, :post_id
  belongs_to :user, counter_cache: true
  belongs_to :post, counter_cache: true
end
