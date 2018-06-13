class CreateSlickrUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_uploads do |t|
      t.references :uploadable, polymorphic: true, index: true
      t.references :slickr_media_upload
      t.jsonb :additional_info, null: false, default: {}
      t.integer :position

      t.timestamps
    end
    add_index :slickr_uploads, :additional_info, using: :gin
  end
end
