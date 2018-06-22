require 'active_admin/helpers/collection'

module ActiveAdmin
  module Views
    module Pages
      # Index class
      class Index < Base
        protected

        def build_collection
          if items_in_collection? ||
             params[:controller] == 'admin/slickr_media_uploads'
            render_index
          else
            render_empty_results and return if params[:q] || params[:scope]
            render_blank_slate
          end
        end
      end
    end
  end
end
