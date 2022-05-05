# frozen_string_literal: true

require 'image_optim'
require 'image_processing/vips'

module Slickr
  # MediaImageUploader
  class MediaImageUploader < Shrine
    ALLOWED_TYPES = %w[image/gif image/jpg image/jpeg image/png image/svg+xml image/svg].freeze
    MAX_SIZE      = 10 * 1024 * 1024 # 10 MB

    plugin :store_dimensions
    plugin :derivatives
    plugin :activerecord
    plugin :pretty_location

    Attacher.validate do
      validate_max_size MAX_SIZE, message: 'is too large (max is 10 MB)'
      validate_mime_type_inclusion ALLOWED_TYPES
    end

    Attacher.default_url do |derivative: nil, **|
      '/image_fallback/fallback.svg' if derivative
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
