# frozen_string_literal: true

module Slickr
  # MetaTag class
  class MetaTag < ApplicationRecord
    self.table_name = 'slickr_meta_tags'

    belongs_to :metatagable, polymorphic: true
  end
end
