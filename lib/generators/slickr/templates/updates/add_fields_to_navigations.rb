class AddFieldsToNavigations < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.include?('slickr_navigations')
      add_column :slickr_navigations, :alt_link_text, :string
      add_column :slickr_navigations, :config_string, :string
    end
  end
end
