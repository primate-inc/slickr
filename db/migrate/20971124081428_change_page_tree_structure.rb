class ChangePageTreeStructure < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.connection.tables.exclude?('slickr_pages')
      remove_column :slickr_pages, :ancestry
      add_column :slickr_pages, :parent_id, :integer
      add_index :slickr_pages, :parent_id
      add_column :slickr_pages, :position, :integer
    end
  end
end
