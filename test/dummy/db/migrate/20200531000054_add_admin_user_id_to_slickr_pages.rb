class AddAdminUserIdToSlickrPages < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.tables.include?('admin_users')
      add_reference :slickr_pages, :admin_user, index: true
    end
  end
end
