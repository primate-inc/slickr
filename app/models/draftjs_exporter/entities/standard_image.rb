# frozen_string_literal: true

module DraftjsExporter
  module Entities
    # Build image embeds for WYSIWYG editor
    class StandardImage
      def call(parent_element, data)
        return unless (image = Slickr::MediaUpload.find_by(id: data[:data][:image][:id]))

        additional_info = OpenStruct.new(data[:data][:image][:additional_info])

        html_attributes = {}
        html_attributes['src']              = image_from_display_key(image, data[:data][:display])
        html_attributes['data-img_caption'] = additional_info[:img_title]
        html_attributes['data-img_credit']  = additional_info[:img_credit]
        html_attributes['alt']              = additional_info[:alt_text]

        element = parent_element.document.create_element('img', html_attributes)
        parent_element.replace(element)
        element
      end

      def image_from_display_key(image, key)
        if key
          image.image_url(key.to_sym)
        else
          image.image_url(:content_1200)
        end
      end
    end
  end
end
