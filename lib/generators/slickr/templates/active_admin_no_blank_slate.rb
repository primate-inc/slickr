require 'active_admin/helpers/collection'

module ActiveAdmin
  module Views
    module Pages
      class Index < Base
        protected
        def build_collection
          if items_in_collection? || params[:controller] == "admin/slickr_images"
            render_index
          else
            if params[:q] || params[:scope]
              render_empty_results
            else
              render_blank_slate
            end
          end
        end
      end
    end
  end
end
