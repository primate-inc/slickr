class SlickrAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :large do
    process resize_to_limit: [1024, 1024]
  end

  version :medium do
    process resize_to_limit: [768, 768]
  end

  version :small do
    process resize_to_limit: [480, 480]
  end

  version :thumbnail do
    process resize_to_fill: [40, 40]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
