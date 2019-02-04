module Slickr
  module PermitAdditionalAdminParams
    extend self

    def push_to_params(resource, params)
      if resource.class.send(:reflect_on_association, :schedule)
        params.push schedule_attributes
      end
      return unless resource.class.send(:reflect_on_association, :meta_tag)
      params.push meta_tag_attributes(resource)
    end

    private

    def schedule_attributes
      {
        schedule_attributes: %i[
          publish_schedule_date publish_schedule_time
        ]
      }
    end

    def meta_tag_attributes(resource)
      {
        meta_tag_attributes: [
          :title_tag, :meta_description, :og_title, :og_description,
          :twitter_title, :twitter_description,
        ],
        "#{resource.class.table_name.singularize}_meta_og_image_attributes": [
          :slickr_media_upload_id
        ],
        "#{resource.class.table_name.singularize}_meta_twitter_image_attributes": [
          :slickr_media_upload_id
        ]
      }
    end
  end
end
