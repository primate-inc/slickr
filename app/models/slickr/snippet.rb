# frozen_string_literal: true

module Slickr
  # Snippets
  class Snippet < ApplicationRecord
    self.table_name = 'slickr_snippets'

    acts_as_list
    validates_presence_of :title
    default_scope { order(position: :asc) }

    belongs_to :slickr_snippets_category,
               foreign_key: 'slickr_snippet_category_id',
               class_name: 'Slickr::SnippetCategory',
               optional: true

    include Slickr::Uploadable
    has_one_slickr_upload(:snippet_main_image, :main_image)

    scope :published, -> { where(published: true) }
  end
end
