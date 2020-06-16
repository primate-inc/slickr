class CreateSlickrHealthChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :slickr_health_checks do |t|
      t.bigint  :healthy_id
      t.string  :healthy_type
      t.string  :check_type
      t.text    :check_result
      t.timestamps
    end
  end
end
