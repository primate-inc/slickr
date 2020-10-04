# frozen_string_literal: true

module Slickr
  # Snippets
  class Snippet < ApplicationRecord
    self.table_name = 'slickr_snippets'

    KINDS = [
      { kind: 'Full snippet', exclude: [] },
      { kind: 'Simple snippet', exclude: %i[image wysiwyg] },
      { kind: 'Simple snippet with image', exclude: %i[wysiwyg] },
      { kind: 'Rich snippet simplified', exclude: %i[subheader] },
      { kind: 'Rich snippet simplified no image', exclude: %i[image subheader] },
      { kind: 'Header and image', exclude: %i[wysiwyg subheader] },
      { kind: 'WYSIWYG', exclude: %i[header subheader image] },
    ].freeze

    acts_as_list
    validates_presence_of :title
    default_scope { order(position: :asc) }

    belongs_to :slickr_snippets_category,
               foreign_key: 'slickr_snippets_category_id',
               class_name: 'Slickr::SnippetsCategory',
               optional: true

    include Slickr::Uploadable
    include Slickr::Restorable
    slickr_restorable
    include PublicActivity::Model
    tracked(
      params: { title: :title, type: 'Snippet' },
      owner: proc { |controller, model| controller.current_admin_user }
    )
    has_one_slickr_upload(:snippet_main_image, :main_image)

    scope :published, -> { where(published: true) }
  end
end
