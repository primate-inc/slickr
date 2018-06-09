# frozen_string_literal: true

module Slickr
  # Upload class
  class Upload < ApplicationRecord
    self.table_name = 'slickr_uploads'

    acts_as_list scope: %i[uploadable_id uploadable_type]

    # optional true to allow the uploadable_type to be customised without
    # the class having to exist which will allow multiple associations
    # on the polymorphic model
    belongs_to :uploadable, polymorphic: true, optional: true
    belongs_to :slickr_media_upload, class_name: 'Slickr::MediaUpload'

    default_scope { order(position: :asc) }
  end
end
