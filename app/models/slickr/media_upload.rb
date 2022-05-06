require 'image_processing/mini_magick'

module Slickr
  class MediaUpload < ApplicationRecord
    self.table_name = 'slickr_media_uploads'
    DROP_AREA_TEXT = 'Maximum size 10Mb | .jpeg, .jpg, .png and .pdf files only'

    DEFAULT_IMAGE_DERIVATIVES = {
      square: {
        square_2400: {
          type: :fill, options: [2400, 2400, { crop: :attention }]
        },
        square_1800: {
          type: :fill, options: [1800, 1800, { crop: :attention }]
        },
        square_1200: {
          type: :fill, options: [1200, 1200, { crop: :attention }]
        },
        square_800: {
          type: :fill, options: [800, 800, { crop: :attention }]
        },
        square_600: {
          type: :fill, options: [600, 600, { crop: :attention }]
        },
        square_400: {
          type: :fill, options: [400, 400, { crop: :attention }]
        }
      },
      landscape: {
        landscape_2400: {
          type: :fill, options: [2400, 1600, { crop: :attention }]
        },
        landscape_1800: {
          type: :fill, options: [1800, 1200, { crop: :attention }]
        },
        landscape_1200: {
          type: :fill, options: [1200, 800, { crop: :attention }]
        },
        landscape_800: {
          type: :fill, options: [800, 534, { crop: :attention }]
        },
        landscape_600: {
          type: :fill, options: [600, 400, { crop: :attention }]
        },
        landscape_400: {
          type: :fill, options: [400, 267, { crop: :attention }]
        }
      },
      portrait: {
        portrait_2400: {
          type: :fill, options: [1600, 2400, { crop: :attention }]
        },
        portrait_1800: {
          type: :fill, options: [1200, 1800, { crop: :attention }]
        },
        portrait_1200: {
          type: :fill, options: [800, 1200, { crop: :attention }]
        },
        portrait_800: {
          type: :fill, options: [534, 800, { crop: :attention }]
        },
        portrait_600: {
          type: :fill, options: [400, 600, { crop: :attention }]
        },
        portrait_400: {
          type: :fill, options: [267, 400, { crop: :attention }]
        }
      },
      panoramic: {
        panoramic_2400: {
          type: :fill, options: [2400, 1350, { crop: :attention }]
        },
        panoramic_1800: {
          type: :fill, options: [1800, 1012, { crop: :attention }]
        },
        panoramic_1200: {
          type: :fill, options: [1200, 675, { crop: :attention }]
        },
        panoramic_800: {
          type: :fill, options: [800, 450, { crop: :attention }]
        },
        panoramic_600: {
          type: :fill, options: [600, 337, { crop: :attention }]
        },
        panoramic_400: {
          type: :fill, options: [400, 225, { crop: :attention }]
        }
      },
      content: {
        content_1200: {
          type: :limit, options: [1200, nil]
        },
        content_800: {
          type: :limit, options: [800, nil]
        },
        content_600: {
          type: :limit, options: [600, nil]
        },
        content_400: {
          type: :limit, options: [400, nil]
        }
      },
      thumb: {
        thumb_800x800: {
          type: :pad, options: [800, 800, { extend: :white }]
        },
        thumb_400x400: {
          type: :pad, options: [400, 400, { extend: :white }]
        },
        thumb_200x200: {
          type: :pad, options: [200, 200, { extend: :white }]
        }
      }
    }

    include AASM
    aasm do
      state :uploaded, initial: true
      state :processed
      state :optimised
      state :thumbnails
      state :resizing
      state :ready

      event :process, after: :optimise_image do
        transitions from: [:uploaded], to: :processed
      end

      event :optimise do
        transitions from: [:processed], to: :optimised
      end

      event :create_thumbnails, after: :process_thumbnails do
        transitions from: [:optimised], to: :thumbnails
      end

      event :resize, after: :send_for_resizing do
        transitions from: [:thumbnails], to: :resizing
      end

      event :finalize do
        transitions from: :resizing, to: :ready
      end
    end

    after_create :process!

    if defined?(acts_as_taggable_on)
      acts_as_taggable_on :media_tags
    end


    include Slickr::MediaImageUploader[:image] rescue NameError
    include Slickr::MediaFileUploader[:file] rescue NameError

    has_many :slickr_uploads, class_name: 'Slickr::Upload'

    scope(:pdf_files, lambda do
      where('file_data @> ?', {
        metadata: { mime_type: 'application/pdf' }
      }.to_json)
    end)

    def process_thumbnails
      send(:send_to_generate_thumbnails)
    end

    def optimise_image
      optimise!
      send(:send_to_optimising)
    end

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
      "#{image_url(:thumb_400x400)}?timestamp=#{DateTime.now.to_s}"
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

    def add_new_derivatives(key)
      ResizeImagesJob.perform_later(self, key)
    end

    def self.additional_derivatives
      {}
    end

    def generate_thumbnails
      resize!
    end

    def admin_file_thumbnail
      path = file_url(:thumb_400x400)
      path = file_url(:optimised) if path.blank?
      path = file_url(:original) if path.blank?

      path
    end

    def admin_image_thumbnail
      path = image_url(:thumb_400x400)
      path = image_url(:optimised) if path.blank? || path.include?(Slickr::MediaImageUploader::FALLBACK_PATH)
      path = image_url if path.blank? || path.include?(Slickr::MediaImageUploader::FALLBACK_PATH)

      path
    end

    private

    def build_file
      {
        id: id,
        src: file_url(:thumb_400x400).present? ? file_url(:thumb_400x400) : '',
        displayPath: file_url(:thumb_400x400).present? ? file_url(:thumb_400x400) : '',
        thumbnail: admin_file_thumbnail,
        thumbnailWidth: file_url(:thumb_400x400).present? ? file(:thumb_400x400).try(:width) : 400,
        thumbnailHeight: file_url(:thumb_400x400).present? ? file(:thumb_400x400).try(:height) : 400,
        caption: file_url(:thumb_400x400).present? ? file.original_filename : '',
        isSelected: false,
        editPath: file_url(:thumb_400x400).present? ? admin_edit_path : '',
        returnMediaPath: file_url(:thumb_400x400).present? ? return_media_path : '',
        mimeType: file_url(:thumb_400x400).present? ? file.mime_type : ''
      }
    end

    def build_image
      {
        id: id,
        src: admin_image_thumbnail,
        displayPath: image_url(:thumb_400x400),
        thumbnail: admin_image_thumbnail,
        thumbnailWidth: 400,
        thumbnailHeight: 400,
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

    def send_to_generate_thumbnails
      CreateImageThumbnailsJob.perform_later(self)
    end

    def send_to_optimising
      OptimiseImageJob.perform_later(self)
    end

    def send_for_resizing
      ResizeImagesJob.perform_later(self, :square)
      ResizeImagesJob.perform_later(self, :portrait)
      ResizeImagesJob.perform_later(self, :landscape)
      ResizeImagesJob.perform_later(self, :panoramic)
      ResizeImagesJob.perform_later(self, :content)
    end
  end
end
