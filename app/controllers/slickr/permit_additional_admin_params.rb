# frozen_string_literal: true

module Slickr
  # PermitAdditionalAdminParams module
  module PermitAdditionalAdminParams
    extend self

    def push_to_params(klass, params)
      if klass.send(:reflect_on_association, :schedule)
        params.push schedule_attributes
      end
      return unless klass.send(:reflect_on_association, :meta_tag)
      params.push meta_tag_attributes(klass)
    end

    private

    def schedule_attributes
      {
        schedule_attributes: %i[
          publish_schedule_date publish_schedule_time
        ]
      }
    end

    def meta_tag_attributes(klass)
      {
        meta_tag_attributes: %i[
          title_tag meta_description og_title og_description twitter_title
          twitter_description
        ],
        "#{klass.table_name.singularize}_meta_og_image_attributes": [
          :slickr_media_upload_id
        ],
        "#{klass.table_name.singularize}_meta_twitter_image_attributes": [
          :slickr_media_upload_id
        ]
      }
    end
  end
end
