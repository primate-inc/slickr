class CreateSlickrSnippets < ActiveRecord::Migration[5.2]
  def change
    create_table :slickr_snippets do |t|
      t.integer :position
      t.string :kind
      t.string :title
      t.string :header
      t.string :subheader
      t.boolean :published, default: false, null: false
      t.text :content

      t.timestamps
    end
  end
end
