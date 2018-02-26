class SlickrImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{Rails.env}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :store_dimensions, if: :image?

  version :large, if: :image? do
    process resize_to_limit: [1024, 1024]
    process :store_dimensions
  end

  version :medium, if: :image? do
    process resize_to_limit: [768, 768]
    process :store_dimensions
  end

  version :small, if: :image? do
    process resize_to_limit: [480, 480]
    process :store_dimensions
  end

  version :thumbnail, if: :image? do
    process resize_to_limit: [480, 180]
    process :store_dimensions
  end

  version :pdf_image_preview, if: :pdf? do
    process :convert_to_image
    process convert: :jpg

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  def extension_white_list
    %w(jpg jpeg png pdf)
  end

  private

  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end

  def pdf?(new_file)
    new_file.content_type.start_with? 'application'
  end

  def store_dimensions
    if file && model
      img = ::Magick::Image::read(file.file).first
      version = version_name.nil? ? :normal : version_name
      model.dimensions = {} if model.dimensions.nil?
      model.dimensions[version] = { width: img.columns, height: img.rows }
    end
  end

  def convert_to_image
    # Most PDFs have a transparent background, which becomes black when converted to jpg.
    # To override this, we must create a white canvas and composite the PDF onto the convas.
    image = ::Magick::Image.read(current_path + "[0]")[0]
    image.resize_to_fit(127,180)
    canvas = ::Magick::Image.new(image.columns, image.rows) { self.background_color = '#FFF' }
    # Merge PDF thumbnail onto canvas
    canvas.composite!(image, ::Magick::CenterGravity, ::Magick::OverCompositeOp)
    canvas.write(current_path)
    image.destroy!
    canvas.destroy!
  end
end
