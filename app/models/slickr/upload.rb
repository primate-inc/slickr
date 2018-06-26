# frozen_string_literal: true

module Slickr
  # Upload class
  class Upload < ApplicationRecord
    self.table_name = 'slickr_uploads'

    after_save :delete_if_no_slickr_media_upload_id

    acts_as_list scope: %i[uploadable_id uploadable_type]

    # optional true to allow the uploadable_type to be customised without
    # the class having to exist which will allow multiple associations
    # on the polymorphic model
    belongs_to :uploadable, polymorphic: true, optional: true
    belongs_to :slickr_media_upload,
               class_name: 'Slickr::MediaUpload',
               optional: true

    default_scope { order(position: :asc) }

    private

    def delete_if_no_slickr_media_upload_id
      destroy if slickr_media_upload_id.nil? ||
                 slickr_media_upload_id.zero? ||
                 slickr_media_upload_id.blank?
    end
  end
end
