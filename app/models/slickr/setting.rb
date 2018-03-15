# RailsSlickr::Setting Model
module Slickr
  class Setting < RailsSettings::Base
    self.table_name = 'slickr_settings'

    source Rails.root.join("config/setting.yml")
    namespace Rails.env
  end
end
