class ResizeImagesJob < ApplicationJob
  def perform(upload, size)
    attacher = upload.image_attacher

    image_optim = ImageOptim.new(
      pngout: false, svgo: false,
      jpegoptim: { allow_lossy: true, max_quality: 85 }
    )

    file = attacher.file.download

    optimized_path = image_optim.optimize_image(file) || file

    optimized = File.open(optimized_path, 'rb')
    pipeline = ImageProcessing::Vips.source(optimized)

    available_derivatives[size].each do |thumb_name, options|
      case options[:type]
      when :fill
        attacher.add_derivative(thumb_name,
          pipeline.resize_to_fill(*options[:options]).call)
      when :limit
        attacher.add_derivative(thumb_name,
          pipeline.resize_to_limit(*options[:options]).call)
      when :fit
        attacher.add_derivative(thumb_name,
          pipeline.resize_to_fit(*options[:options]).call)
      when :pad
        attacher.add_derivative(thumb_name,
          pipeline.resize_and_pad(*options[:options]).call)
      end
    end

    upload.save
  end

  def available_derivatives
    Slickr::MediaUpload::DEFAULT_IMAGE_DERIVATIVES.merge(
      Slickr::MediaUpload.additional_derivatives
    )
  end
end
