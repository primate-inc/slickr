# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Previewable
    extend ActiveSupport::Concern

    included do
      after_save :check_if_html_valid
      has_many :health_checks, as: :healthy
      has_one :validation_check, -> { where(check_type: 'html_validation') }, :class_name=> "Slickr::HealthCheck", as: :healthy

      delegate :html_validation_warnings, :html_validation_errors, to: :validation_check
    end

    def slickr_previewable_locals
      self.class.slickr_previewable_opts[:locals].is_a?(Proc) ?
        self.class.slickr_previewable_opts[:locals].call(self) :
        self.class.slickr_previewable_opts[:locals]
    end

    def slickr_previewable_layout
      self.class.slickr_previewable_opts[:layout].is_a?(Proc) ?
        self.class.slickr_previewable_opts[:layout].call(self) :
        self.class.slickr_previewable_opts[:layout]
    end

    def slickr_previewable_template
      self.class.slickr_previewable_opts[:template].is_a?(Proc) ?
        self.class.slickr_previewable_opts[:template].call(self) :
        self.class.slickr_previewable_opts[:template]
    end

    def slickr_previewable_instance_variables
      return [] if self.class.slickr_previewable_opts[:instance_variables].nil?
      self.class.slickr_previewable_opts[:instance_variables].is_a?(Proc) ?
        self.class.slickr_previewable_opts[:instance_variables].call(self) :
        self.class.slickr_previewable_opts[:instance_variables]
    end

    def check_if_html_valid
      validator = W3CValidators::NuValidator.new
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
      attr_reader :slickr_previewable_opts

      private

      def slickr_previewable(opts = {})
        options = { preview_enabled: true, layout: 'layouts/application', template: "#{self.model_name.plural}/show", locals: {} }.merge(opts)
        @slickr_previewable_opts = options
      end
    end
  end
end
