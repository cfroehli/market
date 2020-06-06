# frozen_string_literal: true

class ProductImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  # Store size
  process resize_to_limit: [640, 480]

  version :standard do
    process resize_to_limit: [640, 480]
  end

  version :thumb do
    process resize_to_limit: [355, 200]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
