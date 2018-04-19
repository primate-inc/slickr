class CreateSlickrNavigations < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_navigations do |t|
      t.integer     :parent_id
      t.references  :slickr_page, index: true
      t.integer     :position
      t.string      :parent_type
      t.string      :child_type
      t.string      :title
      t.string      :image
      t.text        :text
      t.string      :link
      t.string      :link_text

      t.timestamps
    end
    add_index :slickr_navigations, :parent_id
  end
end
