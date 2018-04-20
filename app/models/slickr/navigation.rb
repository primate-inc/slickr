# frozen_string_literal: true

module Slickr
  # Navigation class
  class Navigation < ApplicationRecord
    self.table_name = 'slickr_navigations'

    extend ActsAsTree::TreeWalker
    acts_as_tree order: 'position'
    acts_as_list scope: :parent_id

    PARENT_TYPES = %w[Root General Page].freeze

    CHILD_TYPES = ['Page', 'Custom Link', 'Anchor', 'Header'].freeze

    validates :title, presence: true
    validate :uniqueness_of_root_title
    validate :parent_type_or_child_type

    def self.root_subtree_for_views; end

    def expanded
      root?
    end

    def tree_children
      children.decorate.map do |p|
        {
          id: p.id,
          title: p.title,
          children: p.tree_children,
          position: p.position,
          add_child_path: p.add_child_path,
          edit_page_path: p.edit_page_path,
          admin_delete_navigation_path: p.admin_delete_navigation_path,
          change_position_admin_navigation: p.change_position_admin_navigation
        }
      end
    end

    def add_child_path
      Rails.application.routes.url_helpers.new_admin_slickr_navigation_path(
        parent: id
      )
    end

    def edit_page_path
      Rails.application.routes.url_helpers.edit_admin_slickr_page_path(id)
    end

    def admin_delete_navigation_path
      Rails.application.routes.url_helpers.admin_slickr_navigation_path(id)
    end

    def admin_navigation_path
      Rails.application.routes.url_helpers.admin_slickr_navigations_path
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

    def uniqueness_of_root_title
      return unless root?
      titles = Slickr::Navigation.roots.pluck(:title)
      errors.add(:title, 'already exists') if title.in? titles
    end

    def parent_type_or_child_type
      return unless parent_type.blank? && child_type.blank?
      errors.add(:parent_type, 'specify a type')
      errors.add(:child_type, 'specify a type')
    end
  end
end
