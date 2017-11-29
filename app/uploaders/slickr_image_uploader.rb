class SlickrImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :store_dimensions

  version :large do
    process resize_to_limit: [1024, 1024]
    process :store_dimensions
  end

  version :medium do
    process resize_to_limit: [768, 768]
    process :store_dimensions
  end

  version :small do
    process resize_to_limit: [480, 480]
    process :store_dimensions
  end

  version :thumbnail do
    process resize_to_limit: [480, 180]
    process :store_dimensions
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  private

  def store_dimensions
    if file && model
      img = ::Magick::Image::read(file.file).first
      version = version_name.nil? ? :normal : version_name
      model.dimensions = {} if model.dimensions.nil?
      model.dimensions[version] = { width: img.columns, height: img.rows }
    end
  end
end
