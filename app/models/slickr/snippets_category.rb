# frozen_string_literal: true

module Slickr
  # Snippets category model
  class SnippetsCategory < ApplicationRecord
    self.table_name = 'slickr_snippets_categories'
    has_many :slickr_snippets,
             foreign_key: 'slickr_snippet_id',
             class_name: 'Slickr::Snippet',
             dependent: :nullify
    validates_presence_of :title

    extend FriendlyId
    friendly_id :title, use: %i[slugged finders]

    scope(:snippets_category_search, lambda do |query|
      where('title ilike ?', "%#{query}%")
    end)
  end
end
