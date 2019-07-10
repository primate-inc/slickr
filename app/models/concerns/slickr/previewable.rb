# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Previewable
    extend ActiveSupport::Concern

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
