# frozen_string_literal: true

require 'image_optim'
require 'image_processing/vips'

module Slickr
  # MediaFileUploader
  class MediaFileUploader < Shrine
    plugin :delete_raw # automatically delete processed files after uploading
    plugin :delete_promoted
    plugin :processing
    plugin :store_dimensions
    plugin :versions

    Attacher.validate do
      validate_max_size 10.megabytes, message: 'is too large (max is 10 MB)'
      validate_mime_type_inclusion ['application/pdf']
    end

    process(:store) do |io, context|
      pdf = io.download

      image = MiniMagick::Image.new(pdf.path)
      page = image.pages[0]
      page_image = Tempfile.new('version', binmode: true)

      MiniMagick::Tool::Convert.new do |convert|
        convert.background 'white'
        convert.resize('1800x1800')
        convert.quality 100
        convert << page.path
        convert << page_image.path
      end
      page_image.open # refresh updated file

      pipeline = ImageProcessing::Vips.source(page_image).convert('png')
      l_fit =     pipeline.resize_to_fit!(762, 1080)
      thumb_fit = pipeline.resize_to_fit!(127, 180)

      pdf.close!

      { original: io, large: l_fit, thumb: thumb_fit }
    end

    def generate_location(io, context)
      path = super[/^(.*[\\\/])/]
      version = context[:version]
      is_original = version.nil? || version == :original
      return path + context[:metadata]['filename'] if is_original
      orig_filename = context[:record].file_data['metadata']['filename']
      filename = "#{version}-#{orig_filename.gsub('.pdf', '.png')}"
      path + filename
    end
  end
end
