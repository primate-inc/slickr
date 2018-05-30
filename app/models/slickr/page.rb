module Slickr
  class Page < ApplicationRecord
    self.table_name = 'slickr_pages'

    attr_writer :remove_page_header_image

    extend FriendlyId
    include AASM
    has_paper_trail only: [:title, :aasm_state, :content, :published_content, :drafts],
                    meta: { content_changed: :content_changed? }

    friendly_id :title, use: [:slugged, :finders]
    belongs_to :slickr_image,
               foreign_key: 'slickr_image_id',
               class_name: 'Slickr::Image',
               optional: true
    has_many :slickr_navigations,
             foreign_key: 'slickr_page_id',
             class_name: 'Slickr::Navigation',
             dependent: :destroy
    has_many :drafts, foreign_key: 'slickr_page_id', class_name: 'Draft', dependent: :destroy
    has_one :active_draft, class_name: 'Slickr::Page::Draft'
    has_one :published_draft, class_name: 'Slickr::Page::Draft'

    before_validation :clear_page_header_image
    before_create :create_content_areas
    after_create :create_draft, :activate_draft
    after_save :delete_nav_if_page_unpublished

    validates_presence_of :title, :layout, unless: :type_draft?

    scope :not_draft, -> {where(type: nil)}

    aasm(:status, column: :aasm_state) do
      state :draft, initial: true
      state :published

      event :publish do
        transitions from: :draft, to: :published
      end

      event :unpublish do
        transitions from: :published, to: :draft
      end
    end

    scope(:no_root_or_page_navs, lambda do
      includes(:slickr_navigations)
      .where(aasm_state: :published)
      .where(slickr_navigations: {id: nil})
    end)

    scope(:has_root_or_page_navs, lambda do
      includes(:slickr_navigations)
      .where(aasm_state: :published)
      .where.not(slickr_navigations: {id: nil})
    end)

    def display_title
      title
    end

    def published
      published?
    end

    def slickr_image_path
      return if slickr_image.nil?
      slickr_image.attachment.url
    end

    def create_content_areas
      self.content = {
        "entityMap": {},
        "blocks": [
          {
            "key": SecureRandom.hex(3),
            "text": "",
            "type": "unstyled",
            "depth": 0,
            "inlineStyleRanges": [],
            "entityRanges": [],
            "data": {}
          }
        ]
      };
    end

    def create_draft
      drafts.create
    end

    def activate_draft
      drafts.first.activate
    end

    def preview_page
      Rails.application.routes.url_helpers.preview_admin_slickr_page_path(self.id)
    end

    def admin_unpublish_path
      Rails.application.routes.url_helpers.unpublish_admin_slickr_page_path(self.id)
    end

    def admin_publish_path
      Rails.application.routes.url_helpers.publish_admin_slickr_page_path(self.id)
    end

    def admin_delete_page_path
      Rails.application.routes.url_helpers.admin_slickr_page_path(self.id)
    end

    def edit_page_path
      Rails.application.routes.url_helpers.edit_admin_slickr_page_path(self.id)
    end

    def admin_preview_page_path
      Rails.application.routes.url_helpers.preview_admin_slickr_page_path(self.id)
    end

    def change_position_admin_page
      Rails.application.routes.url_helpers.change_position_admin_slickr_page_path(self.id)
    end

    def admin_page_path
      Rails.application.routes.url_helpers.admin_slickr_page_path(self.id)
    end

    def admin_image_index_path
      Rails.application.routes.url_helpers.admin_slickr_images_path
    end

    def remove_page_header_image
      @remove_page_header_image || false
    end

    def clear_page_header_image
      self.slickr_image_id = nil if remove_page_header_image == true
    end

    private

    def delete_nav_if_page_unpublished
      return unless draft?
      Slickr::Navigation.where(slickr_page_id: id).destroy_all
    end

    def type_draft?
      type == 'Slickr::Page::Draft'
    end
  end
end
