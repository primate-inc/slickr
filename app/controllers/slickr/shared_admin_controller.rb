# frozen_string_literal: true

module Slickr
  # SharedAdminController module
  module SharedAdminController
    def scoped_collection
      if defined?(end_of_association_chain.kept)
        end_of_association_chain.kept
      else
        end_of_association_chain
      end
    end
    def find_resource
      return if params[:id].nil?
      scoped_collection.find(params[:id])
    end
  end
end
