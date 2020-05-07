# frozen_string_literal: true

module Slickr
  # Metatagable module
  module Metatagable
    extend ActiveSupport::Concern
    include Slickr::Uploadable

    included do
      has_one :meta_tag,
              class_name: 'Slickr::MetaTag',
              as: :metatagable,
              dependent: :destroy
      accepts_nested_attributes_for :meta_tag, allow_destroy: true
      has_one_slickr_upload(
        "#{self.table_name.singularize}_meta_og_image".to_sym, :og_image
      )
      has_one_slickr_upload(
        "#{self.table_name.singularize}_meta_twitter_image".to_sym,
        :twitter_image
      )
    end
  end
end
