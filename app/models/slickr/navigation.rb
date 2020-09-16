# frozen_string_literal: true

module Slickr
  # Navigation class
  class Navigation < ApplicationRecord
    self.table_name = 'slickr_navigations'

    include Slickr::Uploadable
    include Slickr::Schedulable

    has_ancestry
    acts_as_list scope: [:ancestry]

    ROOT_TYPES = %w[Root Link Page].freeze

    CHILD_TYPES = ['Page', 'Custom Link', 'Anchor', 'Header'].freeze

    has_one_slickr_upload(:slickr_navigation_image, :image)
    belongs_to :slickr_page,
               foreign_key: 'slickr_page_id',
               class_name: 'Slickr::Page',
               optional: true

    validates :title, presence: true
    validates_uniqueness_of :title, if: proc { |nav| nav.sub_root? }
    validate :root_type_or_child_type
    validate :page_id_if_root_is_page
    validate :parent_not_custom_link
    validate :of_child_bearing_type, if: proc { |nav| nav.has_children? }

    scope(:nav_roots, lambda do
      where.not(root_type: [nil, ''])
      .where.not(root_type: 'slickr_master')
    end)

    def self.all_nav_trees
      first.try(:build_tree_structure)
    end

    def build_tree_structure
      subtree.left_outer_joins(
        :slickr_navigation_image, [slickr_page: :schedule]
      ).select(
        :id, :root_type, :child_type, :slickr_page_id, :title, :text, :link,
        :link_text, :ancestry, 'slickr_uploads.id AS image_id',
        'slickr_pages.id AS page_id', 'slickr_pages.title AS page_title',
        :page_header, :page_intro, :page_subheader, :page_intro, :slug,
        'slickr_schedules.publish_schedule_time AS schedule_time'
      ).arrange_serializable(order: :position)[0]['children']
    end

    def expanded
      sub_root?
    end

    def sub_root
      return self if root_type.present?
      ancestors.where.not(root_type: [nil, ''])
               .where.not(root_type: 'slickr_master')
               .first
    end

    def sub_root?
      root_type.present?
    end

    def tree_children
      children.includes(:slickr_page).order(:position).decorate.map do |n|
        {
          id: n.id,
          title: n.title,
          root_type: n.root_type,
          child_type: n.child_type,
          children: n.tree_children,
          position: n.position,
          subtitle: n.subtitle,
          add_child_path: n.add_child_path,
          admin_edit_navigation_path: n.admin_edit_navigation_path,
          admin_delete_navigation_path: n.admin_delete_navigation_path,
          change_position_admin_navigation: n.change_position_admin_navigation,
          admin_edit_page_path: n.admin_edit_page_path,
          published: n.child_published?,
          ancestor_ids: n.ancestry.split('/').map(&:to_i),
          parent_id: n.parent.id
        }
      end
    end

    def navigation_image
      return { id: nil, path: nil } if image.nil?
      { id: image.id, path: image.image_url(:thumb_400x400) }
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
      if sub_root?
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

    def admin_edit_page_path
      return nil if slickr_page_id.nil?
      Rails.application.routes.url_helpers
           .edit_admin_slickr_page_path(slickr_page_id)
    end

    def admin_image_index_path
      Rails.application.routes.url_helpers.admin_slickr_media_uploads_path
    end

    def change_position_admin_navigation
      Rails.application
           .routes.url_helpers
           .change_position_admin_slickr_navigation_path(id)
    end

    def has_children?
      return unless persisted?

      children.any?
    end

    private

    def root_type_or_child_type
      return unless root_type.blank? && child_type.blank?
      errors.add(:root_type, 'specify a type')
      errors.add(:child_type, 'specify a type')
    end

    def page_id_if_root_is_page
      return unless root_type == 'Page' && slickr_page_id.blank?
      errors.add(:slickr_page_id, 'select a page')
    end

    def parent_not_custom_link
      return unless parent&.child_type && CHILD_TYPES.reject{|t| t == 'Custom Link'}.exclude?(parent.child_type)
      errors.add(:parent, 'cannot be child of custom link')
    end

    def of_child_bearing_type
      return unless children && child_type == 'Custom Link'
      errors.add(:parent, 'you must remove children before becoming a custom link')
    end
  end
end
