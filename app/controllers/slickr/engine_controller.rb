module Slickr
  module EngineController
    include Slickr::Metatags

    def fetch_slickr_settings
      meta_defaults = {og_type: 'article'}
      @slickr_settings = meta_defaults.merge()#Slickr::Setting.get_all)
      @slickr_nav_helper = Slickr::NavigationBuilder.new.nav_helper
    end
  end
end
