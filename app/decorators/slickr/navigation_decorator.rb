# frozen_string_literal: true

module Slickr
  # NavigationDecorator class
  class NavigationDecorator < Draper::Decorator
    delegate_all

    def parent_type_options
      count = Slickr::Navigation.all.count
      return [Slickr::Navigation::PARENT_TYPES[0]] if count.zero?
      Slickr::Navigation::PARENT_TYPES
    end

    def child_type_options
      Slickr::Navigation::CHILD_TYPES
    end

    def children
      tree_children
    end

    def parent_type
      "Parent type: #{parent_type}"
    end

    def child_type
      "Child type: #{child_type}"
    end
  end
end
