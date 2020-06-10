# frozen_string_literal: true

require 'image_optim'
require 'image_processing/vips'

module Slickr
  # MediaImageUploader
  class MediaImageUploader < Shrine
    ALLOWED_TYPES = %w[image/jpg image/jpeg image/png].freeze
    MAX_SIZE      = 10 * 1024 * 1024 # 10 MB

    # plugin :delete_raw # automatically delete processed files after uploading
    plugin :processing
    plugin :store_dimensions
    plugin :derivatives
    plugin :activerecord
    plugin :pretty_location

    Attacher.validate do
      validate_max_size MAX_SIZE, message: 'is too large (max is 10 MB)'
      validate_mime_type_inclusion ALLOWED_TYPES
    end

    Attacher.derivatives do |original|
      image_optim = ImageOptim.new(
        pngout: false, svgo: false,
        jpegoptim: { allow_lossy: true, max_quality: 85 }
      )
      optimized_path = image_optim.optimize_image(original.path) ||
                       original.path
      optimized = File.open(optimized_path, 'rb')
      pipeline = ImageProcessing::Vips.source(optimized)
      record.resize
      {
        optimised: pipeline.call,
        thumb_200x200: pipeline.resize_and_pad(200, 200, extend: :white).call,
        thumb_400x400: pipeline.resize_and_pad(400, 400, extend: :white).call,
        thumb_800x800: pipeline.resize_and_pad(800, 800, extend: :white).call
      }
    end

    def generate_location(io, context)
      path = super[/^(.*[\\\/])/]
      version = context[:derivative]
      is_original = version.nil? || version == :original
      return path + context[:metadata]['filename'].tr(' ', '_') if is_original

      orig_filename = context[:record].image_data['metadata']['filename']
      filename = "#{version}-#{orig_filename.tr(' ', '_')}"
      path + filename
    end
  end
end
