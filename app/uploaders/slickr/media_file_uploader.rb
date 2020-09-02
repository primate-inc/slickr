# frozen_string_literal: true

require 'image_optim'
require 'image_processing/vips'

module Slickr
  # MediaFileUploader
  class MediaFileUploader < Shrine
    ALLOWED_TYPES = %w[application/pdf].freeze
    MAX_SIZE      = 10 * 1024 * 1024 # 10 MB

    plugin :delete_raw # automatically delete processed files after uploading
    plugin :processing
    plugin :store_dimensions

    Attacher.validate do
      validate_max_size MAX_SIZE, message: 'is too large (max is 10 MB)'
      validate_mime_type_inclusion ALLOWED_TYPES
    end

    Attacher.derivatives do |file|
      file.open
      # if file.mime_type == 'application/pdf'
        image = MiniMagick::Image.new(file.path)
        page = image.pages[0]
        display_image = Tempfile.new('version', binmode: true)

        MiniMagick::Tool::Convert.new do |convert|
          convert.background 'white'
          convert.resize('1800x1800')
          convert.quality 100
          convert << page.path
          convert << display_image.path
        end
        display_image.open # refresh updated file
      # else
      #   display_image = document_image('doc')
      # end

      begin
        pipeline = ImageProcessing::Vips.source(display_image)

        {
          optimised: pipeline.call,
          thumb_200x200: pipeline.resize_and_pad(200, 200, extend: :white).call,
          thumb_400x400: pipeline.resize_and_pad(400, 400, extend: :white).call,
          thumb_800x800: pipeline.resize_and_pad(800, 800, extend: :white).call
        }
      rescue Vips::Error
        display_image = document_image('pdf')
        pipeline = ImageProcessing::Vips.source(display_image)

        {
          optimised: pipeline.call,
          thumb_200x200: pipeline.resize_and_pad(200, 200, extend: :white).call,
          thumb_400x400: pipeline.resize_and_pad(400, 400, extend: :white).call,
          thumb_800x800: pipeline.resize_and_pad(800, 800, extend: :white).call
        }
      ensure
        file.close!
      end
    end

    def generate_location(io, context)
      path = super[/^(.*[\\\/])/]
      version = context[:version]
      is_original = version.nil? || version == :original
      return path + context[:metadata]['filename'] if is_original
      orig_filename = context[:record].file_data['metadata']['filename']
      orig_filename_without_type = (/.*(?=\.)/.match orig_filename).to_s
      image_type = context[:metadata]['filename'].split('.')[-1]
      filename = "#{version}-#{orig_filename_without_type}.#{image_type}"
      path + filename
    end

    def document_image(type)
      image = File.join(
        Slickr::Engine.root,
        "package/slickr/media_gallery/files/#{type}_image.jpg"
      )
      File.open(image, 'rb')
    end
  end
end

