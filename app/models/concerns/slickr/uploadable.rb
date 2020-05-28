# frozen_string_literal: true

module Slickr
  # Uploadable module
  module Uploadable
    include ActiveSupport::Concern

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def has_one_slickr_upload(method_symbol, delegate_method_symbol, required=false, options={})
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
        validates_with SlickrImagePresentValidator, method_symbol: method_symbol, required: required
      end

      def has_many_slickr_uploads(method_symbol, delegate_method_symbol, required=false, options={})
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
        validate do |object|
          object.present_if_required(method_symbol) if required == true
        end
      end
    end

    def present_if_required(method_symbol)
      unless send(method_symbol).nil?
        return unless send(method_symbol).slickr_media_upload_id.nil? ||
                      send(method_symbol).slickr_media_upload_id.zero? ||
                      send(method_symbol).slickr_media_upload_id.blank?
      end
      errors.add(method_symbol, "can't be blank")
    end
  end
end
