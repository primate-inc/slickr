class CreatePeople < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.tables.include?('people')
      t.integer :order
      t.string :slug, index: true
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :photo
      t.string :phone
      t.string :email
      t.string :category
      t.string :instagram
      t.string :twitter
      t.string :facebook
      t.string :linkedin
      t.text :description
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end

  def down
    if ActiveRecord::Base.connection.tables.include?('people')
      drop_table :people
    end
  end
end
