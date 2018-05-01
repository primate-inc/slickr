module Slickr
  class Image < ApplicationRecord
    self.table_name = 'slickr_images'

    mount_uploader :attachment, SlickrImageUploader

    has_many :slickr_navigations,
             foreign_key: 'slickr_image_id',
             class_name: 'Slickr::Navigation',
             dependent: :destroy
    has_many :slickr_pages,
             foreign_key: 'slickr_image_id',
             class_name: 'Slickr::Navigation',
             dependent: :destroy

    def build_for_gallery
      extension = File.extname(attachment.file.filename)
      extension == '.pdf' ? build_pdf : build_image
    end

    def admin_edit_path
      Rails.application.routes.url_helpers.edit_admin_slickr_image_path(id)
    end

    def admin_update_path
      Rails.application.routes.url_helpers.admin_slickr_image_path(id)
    end

    def admin_batch_delete_path
      Rails.application.routes.url_helpers.batch_action_admin_slickr_images_path
    end

    def timestamped_image_url
      "#{attachment.url}?timestamp=#{DateTime.now.to_s}"
    end

    def crop(x, y, w, h)
      return if (x || y || w || h) == nil
      image =  Magick::ImageList.new(attachment.current_path)
      cropped_image = image.crop(x, y, w, h)
      cropped_image.write(attachment.current_path)
      attachment.recreate_versions!
    end

    private

    def build_pdf
      {
        id: id,
        src: attachment.url(:pdf_image_preview),
        thumbnail: attachment.url(:pdf_image_preview),
        thumbnailWidth: 127,
        thumbnailHeight: 180,
        caption: attachment.file.filename,
        isSelected: false,
        editPath: admin_edit_path
      }
    end

    def build_image
      {
        id: id,
        src: attachment.url(:large),
        thumbnail: attachment.url(:thumbnail),
        thumbnailWidth: dimensions['thumbnail']['width'],
        thumbnailHeight: dimensions['thumbnail']['height'],
        caption: attachment.file.filename,
        isSelected: false,
        editPath: admin_edit_path
      }
    end
  end
end
