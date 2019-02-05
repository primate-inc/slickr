# frozen_string_literal: true

module Slickr
  # SharedAdminController module
  module SharedAdminController
    def find_resource
      return if params[:id].nil?
      scoped_collection.find(params[:id])
    end
  end
end
