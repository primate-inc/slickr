# frozen_string_literal: true

class ResizeImagesJob < ApplicationJob
  def perform(record, size)
    if record.image_data.present?
      attacher = record.image_attacher
      svg = record.image.mime_type.include?('svg')
      if svg
        available_derivatives[size].each do |thumb_name, options|
          attacher.add_derivative(thumb_name, record.image(:optimised).download)
        end
      else
        record.image(:optimised).open do |io|
          pipeline = ImageProcessing::Vips.source(io)
          available_derivatives[size].each do |thumb_name, options|
            case options[:type]
            when :fill
              attacher.add_derivative(
                thumb_name,
                pipeline.resize_to_fill(*options[:options]).call,
              )
            when :limit
              attacher.add_derivative(
                thumb_name,
                pipeline.resize_to_limit(*options[:options]).call,
              )
            when :fit
              attacher.add_derivative(
                thumb_name,
                pipeline.resize_to_fit(*options[:options]).call,
              )
            when :pad
              attacher.add_derivative(
                thumb_name,
                pipeline.resize_and_pad(*options[:options]).call,
              )
            end
          end
        end
      end

      record.save
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def available_derivatives
    Slickr::MediaUpload::DEFAULT_IMAGE_DERIVATIVES.merge(
      Slickr::MediaUpload.additional_derivatives,
    )
  end
end
