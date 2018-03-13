class RenameSlickrPagesOgTitle2AndOgDescription2 < ActiveRecord::Migration[5.1]
  def change
    rename_column :slickr_pages, :og_title_2, :twitter_title
    rename_column :slickr_pages, :og_description_2, :twitter_description
  end
end
