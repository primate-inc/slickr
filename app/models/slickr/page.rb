module Slickr
  class Page < ApplicationRecord
    self.table_name = 'slickr_pages'

    extend ActsAsTree::TreeWalker
    acts_as_tree order: "position"
    acts_as_list scope: :parent_id
    extend FriendlyId
    include AASM
    has_paper_trail only: [:title, :aasm_state, :content, :published_content, :drafts],
                    meta: { content_changed: :content_changed? }

    friendly_id :title, use: [:slugged, :finders]
    has_many :drafts, foreign_key: "slickr_page_id", class_name: "Draft", dependent: :destroy
    has_one :active_draft, class_name: "Slickr::Page::Draft"
    has_one :published_draft, class_name: "Slickr::Page::Draft"
    before_create :create_content_areas
    after_create :create_draft, :activate_draft
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

    def self.root_subtree_for_views
    end

    def expanded
      root?
    end

    def display_title
      title
    end

    def published
      published?
    end

    def tree_children
      children.not_draft.decorate.map do |p|
        { id: p.id,
          title: p.title,
          add_child_path: p.add_child_path,
          edit_page_path: p.edit_page_path,
          admin_delete_page_path: p.admin_delete_page_path,
          change_position_admin_page: p.change_position_admin_page,
          published: p.published?,
          subtitle: p.subtitle,
          children: p.tree_children,
          position: p.position
        }
      end
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

    def add_child_path
      Rails.application.routes.url_helpers.new_admin_slickr_page_path(parent: self.id)
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
  end
end
