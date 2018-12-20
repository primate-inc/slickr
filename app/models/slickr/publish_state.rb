module Slickr
  class PublishState < ApplicationRecord
    self.table_name = 'slickr_publish_states'

    belongs_to :publishable_state, polymorphic: true

    before_save :set_date_in_publish_schedule_time
    after_save :destroy_if_no_schedule
    after_save :destroy_if_schedule_now_or_past

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
      destroy if publish_schedule_time <= Time.current.utc
    end
  end
end
