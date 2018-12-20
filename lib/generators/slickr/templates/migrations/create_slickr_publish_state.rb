class CreateSlickrPublishState < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_publish_states do |t|
      t.date :publish_schedule_date
      t.datetime :publish_schedule_time
      t.integer :publishable_state_id
      t.string :publishable_state_type

      t.timestamps
    end
  end
end
