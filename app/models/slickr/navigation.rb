# frozen_string_literal: true

module Slickr
  # Navigation class
  class Navigation < ApplicationRecord
    self.table_name = 'slickr_navigations'

    extend ActsAsTree::TreeWalker
    acts_as_tree order: 'position'
    acts_as_list scope: :parent_id

    ROOT_TYPES = %w[Root General Page].freeze

    CHILD_TYPES = ['Page', 'Custom Link', 'Anchor', 'Header'].freeze

    belongs_to :slickr_page, foreign_key: 'slickr_page_id', class_name: 'Slickr::Page', optional: true

    validates :title, presence: true
    validates_uniqueness_of :title, if: proc { |nav| nav.root? }
    validate :root_type_or_child_type

    scope(:nav_roots, lambda do
      where.not(root_type: [nil, ''])
    end)

    def self.root_subtree_for_views; end

    def expanded
      root?
    end

    def tree_children
      children.decorate.map do |n|
        {
          id: n.id,
          title: n.title,
          children: n.tree_children,
          position: n.position,
          subtitle: n.subtitle,
          add_child_path: n.add_child_path,
          admin_edit_navigation_path: n.admin_edit_navigation_path,
          admin_delete_navigation_path: n.admin_delete_navigation_path,
          change_position_admin_navigation: n.change_position_admin_navigation
        }
      end
    end

    def add_child_path
      Rails.application.routes.url_helpers.new_admin_slickr_navigation_path(
        parent_id: id
      )
    end

    def admin_create_navigation_path
      Rails.application.routes.url_helpers.admin_slickr_navigations_path
    end

    def admin_edit_navigation_path
      if root?
        Rails.application.routes.url_helpers
             .edit_admin_slickr_navigation_path(id)
      else
        Rails.application.routes.url_helpers
             .edit_admin_slickr_navigation_path(id, parent_id: parent.id)
      end
    end

    def admin_update_navigation_path
      return if id.nil?
      Rails.application.routes.url_helpers.admin_slickr_navigation_path(id)
    end

    def admin_delete_navigation_path
      Rails.application.routes.url_helpers.admin_slickr_navigation_path(id)
    end


    def admin_image_index_path
      Rails.application.routes.url_helpers.admin_slickr_images_path
    end

    def change_position_admin_navigation
      Rails.application
           .routes.url_helpers
           .change_position_admin_slickr_navigation_path(id)
    end

    private

    def root_type_or_child_type
      return unless root_type.blank? && child_type.blank?
      errors.add(:root_type, 'specify a type')
      errors.add(:child_type, 'specify a type')
    end
  end
end
