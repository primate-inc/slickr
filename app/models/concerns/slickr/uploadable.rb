# frozen_string_literal: true

module Slickr
  # Uploadable module
  module Uploadable
    include ActiveSupport::Concern

    def has_one_slickr_upload(method_symbol, delegate_method_symbol)
      has_one method_symbol,
              -> { where(uploadable_type: method_symbol.to_s) },
              foreign_key: 'uploadable_id',
              class_name: 'Slickr::Upload',
              dependent: :destroy
      accepts_nested_attributes_for method_symbol, allow_destroy: true
      has_one delegate_method_symbol,
              through: method_symbol,
              source: :slickr_media_upload,
              class_name: 'Slickr::MediaUpload'
    end

    def has_many_slickr_uploads(method_symbol, delegate_method_symbol)
      has_many method_symbol,
               -> { where(uploadable_type: method_symbol.to_s) },
               foreign_key: 'uploadable_id',
               class_name: 'Slickr::Upload',
               dependent: :destroy
      accepts_nested_attributes_for method_symbol, allow_destroy: true
      has_many delegate_method_symbol,
               through: method_symbol,
               source: :slickr_media_upload,
               class_name: 'Slickr::MediaUpload'
    end
  end
end
