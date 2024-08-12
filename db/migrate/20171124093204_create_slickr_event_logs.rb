class CreateSlickrEventLogs < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.include?('admin_users')
      create_table :slickr_event_logs do |t|
        t.string :action
        t.references :eventable, polymorphic: true
        t.references :admin_user, foreign_key: true

        t.timestamps
      end
    end
  end
end
