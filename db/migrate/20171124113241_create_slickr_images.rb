if ActiveRecord::Base.connection.tables.exclude?('slickr_images')
  class CreateSlickrImages < ActiveRecord::Migration[5.1]
    def change
      create_table :slickr_images do |t|
        t.string  :attachment
        t.jsonb   :dimensions
        t.jsonb   :data, default: {"alt_text": ""}

        t.timestamps
      end
    end
  end
end
