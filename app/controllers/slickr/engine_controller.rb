module Slickr
  module EngineController
    def fetch_slickr_settings
      @slickr_settings = Slickr::Setting.get_all
    end
  end
end
