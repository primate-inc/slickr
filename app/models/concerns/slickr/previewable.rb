# frozen_string_literal: true

module Slickr
  # Schedulable module
  module Previewable
    extend ActiveSupport::Concern

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
