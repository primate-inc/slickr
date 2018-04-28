require_dependency Slickr::Engine.config.root.join('app', 'uploaders', 'slickr_image_uploader.rb').to_s

class SlickrImageUploader
  # add your additional image sizes here, ensuring to add store_dimensions
  # method in order to save the image sizes
  #
  # version :extend, if: :image? do
  #   process resize_to_limit: [100, 100]
  #   process :store_dimensions
  # end
end
