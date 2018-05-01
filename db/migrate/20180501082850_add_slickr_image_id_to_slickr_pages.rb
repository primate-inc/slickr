class AddSlickrImageIdToSlickrPages < ActiveRecord::Migration[5.1]
  def change
    add_column :slickr_pages, :slickr_image_id, :integer
    add_index :slickr_pages, :slickr_image_id
  end
end
