class AddHeaderImageToSlickrPages < ActiveRecord::Migration[5.1]
  def change
    add_column :slickr_pages, :page_header_image, :string
  end
end
