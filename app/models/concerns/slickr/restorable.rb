# frozen_string_literal: true

module Slickr
  # Restorable module
  module Restorable
    extend ActiveSupport::Concern
    include Discard::Model

    module ClassMethods
      attr_reader :slickr_restorable_opts

      private

      def slickr_restorable(opts = {})
        options = { restorable_method: self.model_name.route_key.to_sym,restorable_model: self.model_name }.merge(opts)
        Slickr::Rubbish.add_restorable(options)
      end

    end
  end
end
