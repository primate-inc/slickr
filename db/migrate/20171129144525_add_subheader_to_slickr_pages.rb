class AddSubheaderToSlickrPages < ActiveRecord::Migration[5.1]
  def change
    add_column :slickr_pages, :page_subheader, :text
  end
end
