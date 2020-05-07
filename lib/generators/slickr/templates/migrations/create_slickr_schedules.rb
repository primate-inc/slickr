class CreateSlickrSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_schedules do |t|
      t.date :publish_schedule_date
      t.datetime :publish_schedule_time
      t.integer :schedulable_id
      t.string :schedulable_type

      t.timestamps
    end
  end
end
