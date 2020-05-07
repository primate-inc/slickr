# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Schedulable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :slickr_schedulable_opts

      private

      def slickr_schedulable(opts = {})
        @slickr_schedulable_opts = opts
      end
    end

    included do
      after_create :schedule_if_requested

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

      private

      def schedule_if_requested
        opts = self.class.try(:slickr_schedulable_opts)
        return if opts.nil?
        make_unpublished if opts[:on_create] == :unpublish
      end

      def make_unpublished
        Slickr::Schedule.create(
          schedulable: self,
          publish_schedule_date: Date.today + 100.years,
          publish_schedule_time: Time.now + 100.years
        )
      end
    end
  end
end
