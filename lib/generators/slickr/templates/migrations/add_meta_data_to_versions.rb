class AddMetaDataToVersions < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.include?('admin_users')
      add_column :versions, :admin_id, :integer, index: true
      add_column :versions, :content_changed, :boolean
    end
  end
end
