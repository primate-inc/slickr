# frozen_string_literal: true

module Slickr
  # Schedule class
  class Schedule < ApplicationRecord
    self.table_name = 'slickr_schedules'

    belongs_to :schedulable, polymorphic: true

    before_save :set_date_in_publish_schedule_time
    after_save :destroy_if_no_schedule
    after_save :destroy_if_schedule_now_or_past
    after_save :unpublish_page
    after_save :publish_page
    after_destroy :publish_page

    scope(:now_or_past, lambda do
      where('publish_schedule_time <= ?', Time.current.utc)
    end)

    private

    def set_date_in_publish_schedule_time
      return if publish_schedule_date.nil?
      self.publish_schedule_time = Time.new(
        publish_schedule_date.year, publish_schedule_date.month,
        publish_schedule_date.day, self.publish_schedule_time.hour,
        self.publish_schedule_time.min, 0
      )
    end

    def destroy_if_no_schedule
      destroy if publish_schedule_date.blank? ||
                 publish_schedule_time.blank?
    end

    def destroy_if_schedule_now_or_past
      return if publish_schedule_time.nil?
      destroy if publish_schedule_time <= Time.current.utc
    end

    def unpublish_page
      return if publish_schedule_time.nil?
      return unless schedulable_type == 'Slickr::Page'
      return unless publish_schedule_time > Time.current.utc
      page = Page.find(schedulable_id)
      return if page.draft?
      page.unpublish!
    end

    def publish_page
      return unless schedulable_type == 'Slickr::Page'
      page = Page.find(schedulable_id)
      return if page.published?
      page.publish! && return if publish_schedule_date.nil?
      return if publish_schedule_time > Time.current.utc
      page.publish!
    end
  end
end
