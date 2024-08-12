# RailsSlickr::Setting Model
module Slickr
  class Setting #< RailsSettings::Base
    def self.get_all
      {}
    end
    #self.table_name = 'slickr_settings'

    #source Rails.root.join("config/setting.yml")
    #namespace Rails.env
  end
end
