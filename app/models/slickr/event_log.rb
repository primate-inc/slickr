module Slickr
  class EventLog < ApplicationRecord
    self.table_name = 'slickr_event_logs'

    belongs_to :eventable, polymorphic: true
    belongs_to :admin_user
  end
end
