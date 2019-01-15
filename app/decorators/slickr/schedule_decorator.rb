# frozen_string_literal: true

module Slickr
  # ScheduleDecorator class
  class ScheduleDecorator < Draper::Decorator
    delegate_all

    def as_select
      pluck(:schedulable_type)
        .map { |type| [type.constantize.model_name.human, type] }
    end
  end
end
