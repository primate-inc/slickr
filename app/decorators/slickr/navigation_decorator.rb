# frozen_string_literal: true

module Slickr
  # NavigationDecorator class
  class NavigationDecorator < Draper::Decorator
    delegate_all

    def root_type_options
      count = Slickr::Navigation.nav_roots.count
      return [Slickr::Navigation::ROOT_TYPES[0]] if count.zero?
      Slickr::Navigation::ROOT_TYPES
    end

    def child_type_options
      Slickr::Navigation::CHILD_TYPES
    end

    def children
      tree_children
    end

    def subtitle
      type = "Type: #{sub_root? ? root_type : child_type}"
      if root_type == 'Page' || child_type == 'Page'
        page = ", Page: #{slickr_page.title}"
        return type + page
      end
      type
    end

    def published
      return unless root_type == 'Page'
      slickr_page.published?
    end

    def child_published?
      return true unless child_type == 'Page'
      slickr_page.published?
    end

    def ancestor_ids
      []
    end
  end
end
