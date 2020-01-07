class Location < ApplicationRecord
  include Geokit::Geocoders
  acts_as_list column: :order
  acts_as_geolocated rescue ActiveAdmin::DatabaseHitDuringLoad

  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  validates_presence_of :name, :address, :phone, :postcode

  before_save :save_lat_lag

  default_scope { order(name: :asc) }

  scope :is_published, -> { where(published: true) }

  private

  def save_lat_lag
    return if Rails.env.test?
    return if address.blank?
    return if postcode.blank?
    return unless (address_changed? || postcode_changed?)
    loc = GoogleGeocoder.geocode("#{self.address}, #{self.city} #{self.postcode}, #{self.country}")
    self.latitude = loc.latitude
    self.longitude = loc.longitude
  end
end
