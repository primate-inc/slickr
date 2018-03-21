# frozen_string_literal: true

# Renaming page meta title column
class RenameSlickrPagesMetaTitle < ActiveRecord::Migration[5.1]
  def change
    rename_column :slickr_pages, :meta_title, :page_title
  end
end
