class AddFieldsToSlickrNavigations < ActiveRecord::Migration[5.1]
  def change
    add_column :slickr_navigations, :config_string, :string
    add_column :slickr_navigations, :alt_link_text, :string
  end
end
