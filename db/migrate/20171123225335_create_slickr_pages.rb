class CreateSlickrPages < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.exclude?('slickr_pages')
      create_table :slickr_pages do |t|
        t.string    :title
        t.string    :slug
        t.string    :ancestry
        t.string    :aasm_state
        t.json      :content, default: "[]"
        t.string    :type
        t.integer   :page_id
        t.integer   :active_draft_id
        t.integer   :published_draft_id
        t.text      :page_header
        t.text      :page_intro
        t.string    :layout
        t.string    :meta_title
        t.text      :meta_description
        t.text      :og_title
        t.text      :og_title_2
        t.text      :og_description
        t.text      :og_description_2
        t.text      :og_image
        t.text      :og_image_2
        t.datetime  :published_at
        t.datetime  :publishing_scheduled_for

        t.timestamps
      end
      add_index :slickr_pages, :slug, unique: true
      add_index :slickr_pages, :ancestry
    end
  end
end
