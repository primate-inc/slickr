class CreateSlickrMetaTags < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_meta_tags do |t|
      t.string    :title_tag
      t.text      :meta_description
      t.text      :og_title
      t.text      :og_description
      t.text      :twitter_title
      t.text      :twitter_description
      t.integer   :metatagable_id
      t.string    :metatagable_type

      t.timestamps
    end
  end
end
