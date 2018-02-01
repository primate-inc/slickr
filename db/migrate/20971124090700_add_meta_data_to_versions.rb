class AddMetaDataToVersions < ActiveRecord::Migration[5.1]
  if ActiveRecord::Base.connection.tables.exclude?('versions')
    def change
      add_column :versions, :admin_id, :integer, index: true
      add_column :versions, :content_changed, :boolean
    end
  end
end
