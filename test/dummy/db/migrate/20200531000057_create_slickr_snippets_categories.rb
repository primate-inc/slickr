class CreateSlickrSnippetsCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :slickr_snippets_categories do |t|
      t.string :title
      t.string :slug
      t.string :header
    end
    add_column :slickr_snippets, :slickr_snippets_category_id, :bigint, index: true
  end
end
