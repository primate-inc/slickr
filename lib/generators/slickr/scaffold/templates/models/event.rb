# frozen_string_literal: true

# Event class
class Event < ApplicationRecord
  paginates_per 4
  include Slickr::Uploadable
  include Slickr::Metatagable
  include Slickr::Schedulable

  extend FriendlyId

  CATEGORIES = %w[category_1 category_2].freeze

  friendly_id :title, use: %i[slugged finders]

  has_one_slickr_upload(:event_header_image, :header_image, true)
  has_one_slickr_upload(:event_thumbnail, :thumbnail)

  validates_presence_of :title, :category

  validates :category, inclusion: { in: ::Event::CATEGORIES.map(&:to_s) }

  filterrific(available_filters: %i[has_category is_published])

  scope(:is_published, lambda do |*_|
    published
  end)

  scope(:has_category, lambda do |categories|
    where(category: categories)
  end)
end
