# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 1, maximum: 60 }
  validates :description, presence: true, length: { minimum: 0, maximum: 1024 }

  has_many :snapshots, class_name: 'ProductSnapshot', inverse_of: :product
  has_many :posts

  scope :enabled, -> { where(enabled: true) }

  mount_uploader :photo, ProductImageUploader

  def snapshot
    snapshots.find_or_create_by(name: name, price: price)
  end
end
