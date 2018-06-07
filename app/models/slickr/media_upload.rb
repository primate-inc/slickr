require 'image_processing/mini_magick'

module Slickr
  class MediaUpload < ApplicationRecord
    self.table_name = 'slickr_media_uploads'

    include Slickr::MediaImageUploader[:image]
    include Slickr::MediaFileUploader[:file]

    def build_for_gallery
      image.present? ? build_image : build_pdf
    end

    def admin_edit_path
      Rails.application.routes.url_helpers
           .edit_admin_slickr_media_upload_path(id)
    end

    def admin_update_path
      Rails.application.routes.url_helpers.admin_slickr_media_upload_path(id)
    end

    def admin_batch_delete_path
      Rails.application.routes.url_helpers
           .batch_action_admin_slickr_media_uploads_path
    end

    def timestamped_image_url
      "#{image_url(:xl_limit)}?timestamp=#{DateTime.now.to_s}"
    end

    def crop(x, y, w, h)
      return if (x || y || w || h).nil?
      storage = Shrine::Storage::FileSystem.new('public').directory.to_s
      full_path = storage + image_url(:original)

      ImageProcessing::MiniMagick.source(full_path)
                                 .crop("#{w}x#{h}+#{x}+#{y}")
                                 .call(destination: full_path)
      update(image: self.image[:original]) # reprocess all images
    end

    private

    def build_pdf
      {
        id: id,
        src: file_url(:l_fit),
        thumbnail: file_url(:thumb_fit),
        thumbnailWidth: file[:thumb_fit].data['metadata']['width'],
        thumbnailHeight: file[:thumb_fit].data['metadata']['height'],
        caption: file[:l_fit].data['metadata']['filename'],
        isSelected: false,
        editPath: admin_edit_path
      }
    end

    def build_image
      {
        id: id,
        src: image_url(:xl_limit),
        thumbnail: image_url(:s_limit),
        thumbnailWidth: image[:s_limit].data['metadata']['width'],
        thumbnailHeight: image[:s_limit].data['metadata']['height'],
        caption: image[:original].data['metadata']['filename'],
        isSelected: false,
        editPath: admin_edit_path
      }
    end
  end
end
