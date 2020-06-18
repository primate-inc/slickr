# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Validable
    extend ActiveSupport::Concern

    included do
      after_save :check_if_html_valid, :check_broken_links
      has_many :health_checks, as: :healthy
      has_one :validation_check, -> { where(check_type: 'html_validation') }, class_name: 'Slickr::HealthCheck', as: :healthy
      has_one :link_check, -> { where(check_type: 'link_validation') }, class_name: 'Slickr::HealthCheck', as: :healthy

      delegate :html_validation_warnings, :html_validation_errors, to: :validation_check
      delegate :link_validation_warnings, :link_validation_errors, to: :link_check
    end

    def check_broken_links
      preview = html_static_preview
      doc = Nokogiri::HTML(preview)
      links = doc.xpath('//a')
      result = links.map do |l|
        link_type = l['href'].match(/^\/.?/) ? :internal : :external
        host = Rails.application.routes.default_url_options[:host].to_s
        link = link_type == :external ? l['href'] : host + l['href']
        begin
          response = HTTP.get(link)
          case response.status.to_s
          when '200'
            { status: response.status, status_group: :success, link: l['href'], link_type: link_type}
          when /^2\d{2}/
            { status: response.status, status_group: :success_other, link: l['href'], link_type: link_type }
          when /^3\d{2}/
            { status: response.status, status_group: :redirect, link: l['href'], link_type: link_type }
          when /^4\d{2}/
            { status: response.status, status_group: :access_error, link: l['href'], link_type: link_type }
          when /^5\d{2}/
            { status: response.status, status_group: :error, link: l['href'], link_type: link_type }
          end
        rescue StandardError => e
          { status: e, status_group: :error, link: l['href'], link_type: link_type }
        end
      end
      build_link_check unless link_check
      link_check.update_attribute(:check_result, result)
    end

    def check_if_html_valid
      validator = ::W3CValidators::NuValidator.new
      preview = html_static_preview
      result = validator.validate_text(preview)
      build_validation_check unless validation_check
      validation_check.update_attribute(:check_result, result)
    end

    def link_valid_symbol
      if link_validation_errors.any?
        "\u274C".encode('utf-8')
      elsif link_validation_warnings.any?
        "\u0021".encode('utf-8')
      else
        "\u2713".encode('utf-8')
      end
    end

    def html_valid_symbol
      if html_validation_errors.any?
        "\u274C".encode('utf-8')
      elsif html_validation_warnings.any?
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

    private

    def html_static_preview
      ApplicationController.render(
        template: slickr_previewable_template,
        layout: slickr_previewable_layout,
        locals: slickr_previewable_locals,
        assigns: slickr_previewable_locals
      )
    end

    module ClassMethods
    end
  end
end
