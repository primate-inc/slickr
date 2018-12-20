# frozen_string_literal: true

module Slickr
  # PublishableState module
  module PublishableState
    extend ActiveSupport::Concern

    included do
      has_one :publish_state,
              class_name: 'Slickr::PublishState',
              as: :publishable_state,
              dependent: :destroy
      accepts_nested_attributes_for :publish_state, allow_destroy: true

      scope(:published, lambda do
        not_published_ids = Slickr::PublishState.where(
          publishable_state_type: klass.to_s
        ).pluck(:publishable_state_id)
        where.not(id: not_published_ids)
      end)
    end
  end
end
