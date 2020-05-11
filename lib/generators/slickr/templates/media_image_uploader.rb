# frozen_string_literal: true

require 'image_optim'
require 'image_processing/vips'

module Slickr
  # MediaImageUploader
  class MediaImageUploader < Shrine
    ALLOWED_TYPES = %w[image/jpg image/jpeg image/png].freeze
    MAX_SIZE      = 10 * 1024 * 1024 # 10 MB

    plugin :delete_raw # automatically delete processed files after uploading
    plugin :processing
    plugin :store_dimensions

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

      begin
      pipeline = ImageProcessing::Vips.source(optimized)
      {
        xxl_limit:   pipeline.resize_to_limit!(1500, 1500),
        xl_limit:    pipeline.resize_to_limit!(1200, 1200),
        l_limit:     pipeline.resize_to_limit!(1000, 1000),
        m_limit:     pipeline.resize_to_limit!(800, 800),
        s_limit:     pipeline.resize_to_limit!(400, 400),
        thumb_limit: pipeline.resize_to_limit!(200, 200),

        xxl_fill:   pipeline.resize_to_fill!(1500, 1500),
        xl_fill:    pipeline.resize_to_fill!(1200, 1200),
        l_fill:     pipeline.resize_to_fill!(800, 800),
        m_fill:     pipeline.resize_to_fill!(600, 600),
        s_fill:     pipeline.resize_to_fill!(400, 400),
        thumb_fill: pipeline.resize_to_fill!(200, 200),

        xxl_fit:   pipeline.resize_to_fit!(1500, 1500),
        xl_fit:    pipeline.resize_to_fit!(1200, 1200),
        l_fit:     pipeline.resize_to_fit!(800, 800),
        m_fit:     pipeline.resize_to_fit!(600, 600),
        s_fit:     pipeline.resize_to_fit!(400, 400),
        thumb_fit: pipeline.resize_to_fit!(200, 200)
      }
      rescue Vips::Error
        {}
      ensure
        original.close!
      end
    end

    def generate_location(io, context)
      path = super[/^(.*[\\\/])/]
      version = context[:version]
      is_original = version.nil? || version == :original
      return path + context[:metadata]['filename'].tr(' ', '_') if is_original
      orig_filename = context[:record].image_data['metadata']['filename']
      filename = "#{version}-#{orig_filename.tr(' ', '_')}"
      path + filename
    end
  end
end
