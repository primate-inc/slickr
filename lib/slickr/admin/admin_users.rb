ActiveAdmin.register AdminUser, as: "Users" do

  menu priority: 10
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :role, :avatar

  scope :all, default: true
  scope("Authors") {|scope| scope.where(role: "author")}

  config.clear_action_items!

  index do |resource|
    selectable_column
    column "" do |user|
      image_tag user.avatar.thumbnail.url.to_s, class: 'display-avatar'
    end
    column :first_name
    column :last_name
    column :email
    column "Role" do |user|
      "#{user.role.capitalize}"
    end
    actions
  end

  show do
    render 'show'
    active_admin_comments
  end

  filter :email

  form html: { id: 'split_display_with_image' } do |f|
    f.inputs 'User avatar' do
      if resource.avatar.url.present?
        div class: 'image' do
          image_tag resource.avatar
        end
      end
      f.input :avatar, as: :file_modified, label: 'Select user avatar'
    end
    f.inputs class: 'form_inputs' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :role, as: :select, collection: AdminUser::ROLES.map{|i| [i.to_s.humanize, i]} if current_admin_user.admin?
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  action_item :edit_user, only: :show do |user|
    if authorized?(:manage, user)
      link_to edit_admin_user_path do
        raw("<svg class='svg-icon'><use xlink:href='#svg-edit' /></svg>Edit user")
      end
    end
  end

  action_item :new_user, only: :index do
    link_to new_admin_user_path do
      raw("<svg class='svg-icon'><use xlink:href='#svg-plus' /></svg>Add user")
    end
  end

  controller do
    def update
      if params[:admin_user][:password].blank? && params[:admin_user][:password_confirmation].blank?
        params[:admin_user].delete('password')
        params[:admin_user].delete('password_confirmation')
      end
      update! do |format|
        format.html { redirect_to edit_admin_user_path(resource), notice: 'User updated' }
      end
    end
  end

end
