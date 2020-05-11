class Person < ApplicationRecord
  CATEGORIES = %i[staff board]

  acts_as_list column: :order
  extend FriendlyId

  friendly_id :nameslug, use: %i[slugged finders]

  include Slickr::Uploadable
  include Slickr::Metatagable
  include Slickr::Previewable
  has_one_slickr_upload(:person_photo, :photo)

  validates :first_name, presence: true

  default_scope { order(order: :asc) }
  scope :is_published, -> { where(published: true) }

  def nameslug
    [first_name, last_name].reject(&:blank?).join("-").parameterize
  end
end
