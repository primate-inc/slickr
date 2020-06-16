# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Validable
    extend ActiveSupport::Concern

    included do
      after_save :check_if_html_valid
      has_many :health_checks, as: :healthy
      has_one :validation_check, -> { where(check_type: 'html_validation') }, :class_name=> "Slickr::HealthCheck", as: :healthy

      delegate :html_validation_warnings, :html_validation_errors, to: :validation_check
    end

    def check_if_html_valid
      validator = ::W3CValidators::NuValidator.new
      preview = ApplicationController.render(
        template: slickr_previewable_template,
        layout: slickr_previewable_layout,
        locals: slickr_previewable_locals,
        assigns: slickr_previewable_locals
      )
      result = validator.validate_text(preview)
      build_validation_check unless validation_check
      validation_check.update_attribute(:check_result, result)
    end

    def html_valid_symbol
      if html_validation_errors.any?
        "\u274C".encode('utf-8')
      elsif html_validation_errors.any?
        "\u0021".encode('utf-8')
      else
        "\u2713".encode('utf-8')
      end
    end

    def html_valid_string
      if html_validation_errors.any? || html_validation_errors.any?
        [
          { name: :error, count: html_validation_errors.count },
          { name: :warning, count: html_validation_warnings.count}
        ].reject { |o| o[:count].zero? }.map { |o|
          "#{pluralize(o[:count], o[:name].to_s)}"
        }.join(", ")
      else
        "No issues"
      end
    end

    module ClassMethods
    end
  end
end
