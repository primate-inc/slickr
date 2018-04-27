# frozen_string_literal: true

module Slickr
  # Navigation class
  class Navigation < ApplicationRecord
    self.table_name = 'slickr_navigations'

    has_ancestry
    acts_as_list scope: [:ancestry]

    ROOT_TYPES = %w[Root Link Page].freeze

    CHILD_TYPES = ['Page', 'Custom Link', 'Anchor', 'Header'].freeze

    belongs_to :slickr_page,
               foreign_key: 'slickr_page_id',
               class_name: 'Slickr::Page',
               optional: true

    validates :title, presence: true
    validates_uniqueness_of :title, if: proc { |nav| nav.sub_root? }
    validate :root_type_or_child_type
    validate :page_id_if_root_is_page

    scope(:nav_roots, lambda do
      where.not(root_type: [nil, ''])
      .where.not(root_type: 'slickr_master')
    end)

    def self.nav_helper
      nav_trees = Slickr::Navigation.all_nav_trees
      pathnames = all_pages_pathnames(nav_trees)
      {
        pathnames: pathnames,
        nav_menus: all_nav_menus(nav_trees, pathnames)
      }
    end

    # example result
    # [{:page_id=>1, :path=>"/level1"}, {:page_id=>2, :path=>"/level1/level2"}]
    def self.all_pages_pathnames(nav_trees)
      main_page_paths = build_main_page_paths(nav_trees)
      additonal_page_paths = build_additonal_page_paths(
        nav_trees, main_page_paths
      )
      main_page_paths + additonal_page_paths
    end

    def self.all_nav_menus(nav_trees, pathnames)
      menu_hash = {}
      nav_trees.map do |root|
        menu_hash[root['title']] = root['children'].map do |child_hash|
          if root['root_type'] == 'Page'
            parent_link = pathnames.select do |path|
              path[:page_id] == root['page_id']
            end[0][:path]
          else
            parent_link = '/'
          end
          build_nav(child_hash, pathnames, {}, parent_link)
        end
      end
      menu_hash
    end

    def self.build_nav(child_hash, pathnames, hash, parent_link)
      if child_hash['child_type'] == 'Page'
        parent_link = pathnames.select do |path|
          path[:page_id] == child_hash['page_id']
        end[0][:path]
      else
        parent_link = parent_link
      end
      menu_hash = case child_hash['child_type']
      when 'Page'
        build_page_nav(child_hash, pathnames)
      when 'Header'
        build_header_nav(child_hash, pathnames)
      when 'Custom Link'
        build_custom_link_nav(child_hash, pathnames)
      when 'Anchor'
        build_anchor_link_nav(child_hash, pathnames, parent_link)
      end
      menu_hash['children'] = child_hash['children'].map do |child_hash|
        build_nav(child_hash, pathnames, menu_hash, parent_link)
      end
      menu_hash
    end

    def self.build_page_nav(hash, pathnames)
      {
        title: hash['title'],
        image: hash['image'] ? hash['image'] : hash['page_header_image'],
        text: {
          text: hash['text'], page_header: hash['page_header'],
          page_into: hash['page_into']
        },
        link: pathnames.select do |path|
          path[:page_id] == hash['page_id']
        end[0][:path],
        link_text: hash['link_text'] ? hash['link_tex'] : hash['title']
      }
    end

    def self.build_header_nav(hash, pathnames)
      {
        title: hash['title'],
        image: hash['image'],
        text: hash['text']
      }
    end

    def self.build_custom_link_nav(hash, pathnames)
      {
        title: hash['title'],
        image: hash['image'],
        text: hash['text'],
        link: hash['link'],
        link_text: hash['link_text']
      }
    end

    def self.build_anchor_link_nav(hash, pathnames, parent_link)
      {
        title: hash['title'],
        image: hash['image'],
        text: hash['text'],
        link: parent_link + hash['link'],
        link_text: hash['link_text']
      }
    end

    def self.all_nav_trees
      first.build_tree_structure[0]['children']
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
      children.order(:position).decorate.map do |n|
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
          admin_edit_page_path: n.admin_edit_page_path
        }
      end
    end

    def build_tree_structure
      subtree.left_outer_joins(:slickr_page).select(
        :id, :root_type, :child_type, :slickr_page_id, :title, :image, :text,
        :link, :link_text, :ancestry,
        'slickr_pages.id AS page_id', 'slickr_pages.title AS page_title',
        :page_header, :page_intro, :page_subheader, :page_intro,
        :page_header_image, :slug
      ).arrange_serializable(order: :position)
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
      Rails.application.routes.url_helpers.admin_slickr_images_path
    end

    def change_position_admin_navigation
      Rails.application
           .routes.url_helpers
           .change_position_admin_slickr_navigation_path(id)
    end

    private

    # build up all of the pathnames nested under a root_type of 'Root'
    # example result
    # [{:page_id=>1, :path=>"/level1"}, {:page_id=>2, :path=>"/level1/level2"}]
    private_class_method def self.build_main_page_paths(nav_trees)
      navs = nav_trees.map { |root| root if root['root_type'] == 'Root' }
      navs.compact.map do |hash|
        iterate_children_for_pathnames(hash, '/')
      end.flatten
    end

    # build up all of the pathnames nested under a root_type of 'Page'
    # the pathnames and associated page id is also passed in to allow these
    # pathnames to build upon the main pathnames
    # example result
    # [{:page_id=>3, :path=>"/level1/level2/level3"}]
    private_class_method def self.build_additonal_page_paths(
      nav_trees, main_page_paths
    )
      navs = nav_trees.map { |root| root if root['root_type'] == 'Page' }
      navs.compact.map do |hash|
        start_path_name = main_page_paths.select do |path|
          path[:page_id] == hash['page_id']
        end
        iterate_children_for_pathnames(hash, "#{start_path_name[0][:path]}/")
      end.flatten
    end

    # will iterate the children of the hash passed in.
    private_class_method def self.iterate_children_for_pathnames(hash, pathname)
      hash['children'].map do |child_hash|
        build_page_pathnames(child_hash, pathname, [])
      end
    end

    # Keeps iterating through the deeply nested hash in order to generate an
    # array of hashed with keys of page_id and path
    private_class_method def self.build_page_pathnames(hash, pathname, array)
      if hash['child_type'] == 'Page'
        new_pathname = pathname + hash['slug']
        array.push(page_id: hash['page_id'], path: new_pathname)
        hash['children'].map do |child_hash|
          build_page_pathnames(child_hash, "#{new_pathname}/", array)
        end
      end
      if hash['child_type'] == 'Header'
        hash['children'].map do |child_hash|
          build_page_pathnames(child_hash, pathname, array)
        end
      end
      array
    end

    def root_type_or_child_type
      return unless root_type.blank? && child_type.blank?
      errors.add(:root_type, 'specify a type')
      errors.add(:child_type, 'specify a type')
    end

    def page_id_if_root_is_page
      return unless root_type == 'Page' && slickr_page_id.blank?
      errors.add(:slickr_page_id, 'select a page')
    end
  end
end
