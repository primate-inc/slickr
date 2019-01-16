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
        where.not(id: Slickr::Schedule.ids_of_type(klass.to_s))
      end)

      scope(:unpublished, lambda do
        where(id: Slickr::Schedule.ids_of_type(klass.to_s))
      end)

      scope(:published_filter, lambda do |yes_no|
        return published if yes_no == 'Yes'
        unpublished
      end)

      # makes listed scopes available in Active Admin filters
      def self.ransackable_scopes(_auth_object = nil)
        %i[published_filter]
      end

      def published?
        schedule.nil?
      end
    end
  end
end
