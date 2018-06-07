class CreateSlickrMediaUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_media_uploads do |t|
      t.text  :image_data
      t.text  :file_data
      t.jsonb :additional_info, default: { 'alt_text': '' }

      t.timestamps
    end
  end
end
