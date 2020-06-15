class CreateSlickrNavigations < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_navigations do |t|
      t.string      :ancestry
      t.references  :slickr_page
      t.integer     :position
      t.string      :root_type
      t.string      :child_type
      t.string      :title
      t.text        :text
      t.string      :link
      t.string      :link_text

      t.timestamps
    end
    add_index :slickr_navigations, :ancestry
  end
end
