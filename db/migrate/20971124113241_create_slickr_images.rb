class CreateSlickrImages < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.exclude?('slickr_event_logs')
      create_table :slickr_images do |t|
        t.string  :attachment
        t.jsonb   :dimensions
        t.jsonb   :data, default: {"alt_text": ""}

        t.timestamps
      end
    end
  end
end
