# frozen_string_literal: true

module Slickr
  # Metatagable module
  module Metatagable
    extend ActiveSupport::Concern
    include Slickr::Uploadable

    TITLE_FIELDS = %i[title_tag og_title twitter_title].freeze
    DESCRIPTION_FIELDS = %i[
      meta_description og_description twitter_description
    ].freeze

    included do
      has_one :meta_tag,
              class_name: 'Slickr::MetaTag',
              as: :metatagable,
              dependent: :destroy

      before_save :save_defaults

      accepts_nested_attributes_for :meta_tag, allow_destroy: true
      has_one_slickr_upload(
        "#{self.table_name.singularize}_meta_og_image".to_sym, :og_image
      )
      has_one_slickr_upload(
        "#{self.table_name.singularize}_meta_twitter_image".to_sym,
        :twitter_image
      )

      def save_defaults
        return unless slickr_metatagable_default && meta_tag

        update_meta_titles if slickr_metatagable_title
        update_meta_descriptions if slickr_metatagable_description
      end

      def update_meta_titles
        TITLE_FIELDS.each do |value|
          update_meta_title(value)
        end
      end

      def update_meta_descriptions
        DESCRIPTION_FIELDS.each do |value|
          update_meta_description(value)
        end
      end

      def update_meta_title(option)
        return unless self.changes[slickr_metatagable_title] || meta_tag.send(option).blank?

        value = self.changes[slickr_metatagable_title].try(:first) || self.send(slickr_metatagable_title)
        if meta_tag.send(option) == value || meta_tag.send(option).blank?
          meta_tag.update_attribute(option, self.send(slickr_metatagable_title))
        end
      end

      def update_meta_description(option)
        return unless self.changes[slickr_metatagable_description] || meta_tag.send(option).blank?

        value = self.changes[slickr_metatagable_description].try(:first) || self.send(slickr_metatagable_description)
        if meta_tag.send(option) == value || meta_tag.send(option).blank?
          meta_tag.update_attribute(option, self.send(slickr_metatagable_description))
        end
      end

      def slickr_metatagable_default
        self.class.slickr_metatagable_opts[:defaults]
      end

      def slickr_metatagable_title
        self.class.slickr_metatagable_opts[:title]
      end

      def slickr_metatagable_description
        self.class.slickr_metatagable_opts[:description]
      end
    end

    module ClassMethods
      def slickr_metatagable_opts
        @slickr_metatagable_opts ||
          { defaults: false, title: nil, description: nil, image: nil }
      end

      private

      def slickr_metatagable(opts = {})
        options = {
          defaults: false, title: nil, description: nil, image: nil
        }.merge(opts)
        @slickr_metatagable_opts = options
      end
    end
  end
end
