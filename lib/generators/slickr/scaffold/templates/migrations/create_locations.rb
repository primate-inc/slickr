class CreateLocations < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.tables.include?('locations')
      create_table :locations do |t|
        t.string :slug, index: true
        t.integer :order
        t.string :name
        t.string :address
        t.string :address_2
        t.string :city
        t.string :country
        t.string :postcode
        t.string :phone
        t.string :email
        t.boolean :published, null: false, default: false
        t.decimal :latitude, precision: 10, scale: 6
        t.decimal :longitude, precision: 10, scale: 6

        t.timestamps
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.tables.include?('locations')
      drop_table :locations
    end
  end
end
