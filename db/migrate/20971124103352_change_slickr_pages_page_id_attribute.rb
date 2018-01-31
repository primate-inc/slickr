class ChangeSlickrPagesPageIdAttribute < ActiveRecord::Migration[5.1]
  def change
    rename_column :slickr_pages, :page_id, :slickr_page_id
  end
end
