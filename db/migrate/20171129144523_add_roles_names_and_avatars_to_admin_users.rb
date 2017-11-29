class AddRolesNamesAndAvatarsToAdminUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :role, :string
    add_column :admin_users, :first_name, :string
    add_column :admin_users, :last_name, :string
    add_column :admin_users, :avatar, :string
  end
end
