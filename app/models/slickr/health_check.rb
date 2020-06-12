# frozen_string_literal: true

module Slickr
  # Upload class
  class HealthCheck < ApplicationRecord
    self.table_name = 'slickr_health_checks'

    belongs_to :healthy, polymorphic: true, optional: true
    serialize :check_result

    def html_validation_errors
      check_result.errors
    end

    def html_validation_warnings
      check_result.warnings
    end
  end
end
