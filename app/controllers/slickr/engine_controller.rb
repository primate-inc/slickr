# module Slickr
#   module EngineController
#     def fetch_slickr_settings
#       meta_defaults = {og_type: 'article'}
#       @slickr_settings = meta_defaults.merge(Slickr::Setting.get_all)
#       @slickr_nav_helper = Slickr::NavigationBuilder.new.nav_helper
#     end
#   end
# end
module Slickr
  module EngineController
    def fetch_slickr_settings
      meta_defaults = {og_type: 'article'}
      @slickr_settings = meta_defaults.merge(Slickr::Setting.get_all)
      is_preview = params[:action] == "preview"

      @slickr_nav_helper = Slickr::NavigationBuilder.new.nav_helper(is_preview)
    end
  end
end