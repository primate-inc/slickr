class ChangeSlickrPagesPageIdAttribute < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.include?('slickr_pages')
      rename_column :slickr_pages, :page_id, :slickr_page_id
    end
  end
end
