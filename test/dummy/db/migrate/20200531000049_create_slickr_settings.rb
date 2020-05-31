class CreateSlickrSettings < ActiveRecord::Migration[5.1]
  def self.up
    create_table :slickr_settings do |t|
      t.string  :var,        null: false
      t.text    :value,      null: true
      t.integer :thing_id,   null: true
      t.string  :thing_type, null: true, limit: 30
      t.timestamps
    end

    add_index :slickr_settings, %i(thing_type thing_id var), unique: true
  end

  def self.down
    drop_table :slickr_settings
  end
end
