module Slickr
  module EngineController
    def fetch_slickr_settings
      meta_defaults = {og_type: 'article'}
      @slickr_settings = meta_defaults.merge(Slickr::Setting.get_all)
    end
  end
end
