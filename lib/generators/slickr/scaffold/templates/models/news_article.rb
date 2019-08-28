# frozen_string_literal: true

# News class
class NewsArticle < ApplicationRecord
  paginates_per 4
  include Slickr::Uploadable
  include Slickr::Metatagable
  include Slickr::Schedulable

  extend FriendlyId

  CATEGORIES = %w[news blog].freeze

  friendly_id :title, use: %i[slugged finders]

  has_one_slickr_upload(:news_header_image, :header_image, true)
  has_one_slickr_upload(:news_thumbnail, :thumbnail)

  validates_presence_of :title, :category

  validates :category, inclusion: { in: ::NewsArticle::CATEGORIES.map(&:to_s) }

  filterrific(available_filters: %i[has_category is_published])

  scope(:is_published, lambda do |*_|
    published
  end)

  scope(:has_category, lambda do |categories|
    where(category: categories)
  end)
end
