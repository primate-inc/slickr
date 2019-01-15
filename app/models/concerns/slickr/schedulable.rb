# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Schedulable
    extend ActiveSupport::Concern

    included do
      has_one :schedule,
              class_name: 'Slickr::Schedule',
              as: :schedulable,
              dependent: :destroy
      accepts_nested_attributes_for :schedule, allow_destroy: true

      scope(:published, lambda do
        not_published_ids = Slickr::Schedule.where(
          schedulable_type: klass.to_s
        ).pluck(:schedulable_id)
        where.not(id: not_published_ids)
      end)

      def published?
        schedule.nil?
      end
    end
  end
end
