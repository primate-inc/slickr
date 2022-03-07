# frozen_string_literal: true

class ResizeImagesJob < ApplicationJob
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def perform(upload, size)
    upload = upload.class.find(upload.id) # make sure we're up to date
    attacher = upload.image_attacher

    image_optim = ImageOptim.new(
      pngout: false, svgo: false,
      jpegoptim: { allow_lossy: true, max_quality: 85 }
    )

    if upload.image(:optimised)
      source = upload.image(:optimised)
      file = source.download
      optimized_path = file
    else
      source = attacher.file
      file = source.download
      optimized_path = image_optim.optimize_image(file)
    end

    File.open(optimized_path, 'rb') do |optimized|
      pipeline = ImageProcessing::Vips.source(optimized)

      available_derivatives[size].each do |name, options|
        case options[:type]
        when :fill
          attacher.add_derivative(name,
                                  pipeline.resize_to_fill(*options[:options]).call)
        when :limit
          attacher.add_derivative(name,
                                  pipeline.resize_to_limit(*options[:options]).call)
        when :fit
          attacher.add_derivative(name,
                                  pipeline.resize_to_fit(*options[:options]).call)
        when :pad
          attacher.add_derivative(name,
                                  pipeline.resize_and_pad(*options[:options]).call)
        end
      end
    end

    upload.save
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def available_derivatives
    Slickr::MediaUpload::DEFAULT_IMAGE_DERIVATIVES.merge(
      Slickr::MediaUpload.additional_derivatives
    )
  end
end
