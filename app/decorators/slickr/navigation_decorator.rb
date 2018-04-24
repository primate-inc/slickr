# frozen_string_literal: true

module Slickr
  # NavigationDecorator class
  class NavigationDecorator < Draper::Decorator
    delegate_all

    def root_type_options
      count = Slickr::Navigation.all.count
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
      if root?
        "Type: #{root_type}"
      elsif child_type == 'Page'
        "Navigation type: #{child_type},
        Page: #{Slickr::Page.find(slickr_page_id).title}"
      else
        "Navigation type: #{child_type}"
      end
    end
  end
end
