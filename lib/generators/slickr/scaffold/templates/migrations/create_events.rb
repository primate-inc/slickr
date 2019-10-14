class CreateEvents < ActiveRecord::Migration[5.1]
  def up
    unless ActiveRecord::Base.connection.tables.include?('events')
      create_table :events do |t|
        t.string :slug, index: true
        t.string :title
        t.boolean :featured, default: false, null: false
        t.text :header
        t.text :subheader
        t.string :category
        t.string :header_image
        t.string :thumbnail
        t.text :content
        t.string :location
        t.date :start_date
        t.date :end_date
        t.time :start_time
        t.time :end_time

        t.timestamps
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.tables.include?('events')
      drop_table :events
    end
  end
end
