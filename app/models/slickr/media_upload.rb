require 'image_processing/mini_magick'

module Slickr
  class MediaUpload < ApplicationRecord
    DROP_AREA_TEXT = 'Maximum size 10Mb | .jpeg, .jpg, .png and .pdf files only'

    self.table_name = 'slickr_media_uploads'

    include Slickr::MediaImageUploader[:image] rescue NameError
    include Slickr::MediaFileUploader[:file] rescue NameError

    has_many :slickr_uploads, class_name: 'Slickr::Upload'

    scope(:pdf_files, lambda do
      where('file_data @> ?', {
        original: { metadata: { mime_type: 'application/pdf' } }
      }.to_json)
    end)

    def self.allowed_upload_info
      allowed_mime_types = Slickr::MediaFileUploader::ALLOWED_TYPES +
                           Slickr::MediaImageUploader::ALLOWED_TYPES
      drop_area_text = DROP_AREA_TEXT
      {
        allowed_mime_types: allowed_mime_types.join(', '),
        file_mime_types: Slickr::MediaFileUploader::ALLOWED_TYPES.to_json,
        image_mime_types: Slickr::MediaImageUploader::ALLOWED_TYPES.to_json,
        drop_area_text: drop_area_text
      }
    end

    def self.additional_info
      {
        create_path: Rails.application.routes.url_helpers
                          .admin_slickr_media_uploads_path
      }
    end

    def build_for_gallery
      image.present? ? build_image : build_file
    end

    def admin_edit_path
      Rails.application.routes.url_helpers
           .edit_admin_slickr_media_upload_path(id)
    end

    def admin_update_path
      Rails.application.routes.url_helpers.admin_slickr_media_upload_path(id)
    end

    def return_media_path
      Rails.application.routes.url_helpers
           .return_media_path_admin_slickr_media_uploads_path
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


    def open_uri_options
      return {} unless Rails.configuration.try(:slickr_http_basic_auth_required)
      {
        http_basic_authentication: [
          Rails.configuration.slickr_http_basic_auth_user,
          Rails.configuration.slickr_http_basic_auth_password
        ]
      }
    end

    private

    def build_file
      return build_empty_image unless file.respond_to?(:keys)
      {
        id: id,
        src: file_url(:large),
        displayPath: file_url(:large),
        thumbnail: file_url(:thumb),
        thumbnailWidth: file[:thumb].data['metadata']['width'],
        thumbnailHeight: file[:thumb].data['metadata']['height'],
        caption: file[:original].data['metadata']['filename'],
        isSelected: false,
        editPath: admin_edit_path,
        returnMediaPath: return_media_path,
        mimeType: file[:original].data['metadata']['mime_type']
      }
    end

    def build_image
      return build_empty_image unless image_data['derivatives']
      {
        id: id,
        src: image_url(:xl_limit),
        displayPath: image_url(:m_limit),
        thumbnail: image_url(:s_limit),
        thumbnailWidth: image(:s_limit).width,
        thumbnailHeight: image(:s_limit).height,
        caption: image.original_filename,
        isSelected: false,
        editPath: admin_edit_path,
        returnMediaPath: return_media_path,
        mimeType: image.mime_type
      }
    end

    # used when the image processing has failed but still need to return some
    # some information for rendering in the media gallery
    def build_empty_image
      {
        id: id, src: '', displayPath: '', thumbnail: '',
        thumbnailWidth: 127, thumbnailHeight: 180,
        caption: '', isSelected: false, editPath: '', mimeType: ''
      }
    end
  end
end
