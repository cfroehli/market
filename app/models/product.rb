class Product < ApplicationRecord
  validates :name, presence: :true, uniqueness: { case_sensitive: false }, length: { minimum: 1, maximum: 60 }
  validates :description, presence: :true, length: { minimum: 0, maximum: 1024 }

  scope :enabled, ->{ where(enabled: true) }

  mount_uploader :photo, ProductImageUploader
end
