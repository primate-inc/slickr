ActiveAdmin.register AdminUser, as: 'SlickrUser' do
  includes :admin_user_avatar

  menu priority: 100
  permit_params :email, :password, :password_confirmation, :first_name,
                :last_name, :role,
                slickr_admin_user_avatar_attributes: [:slickr_media_upload_id]

  scope :all, default: true

  config.clear_action_items!

  index do |resource|
    selectable_column
    column '' do |user|
      if user.admin_user_avatar
        image_tag user.admin_user_avatar.image_url(:square_400),
                  class: 'display-avatar'
      end
    end
    column :first_name
    column :last_name
    column :email
    column "Role" do |user|
      "#{user.role.try(:capitalize)}"
    end
    actions
  end

  show do
    render 'show'
  end

  filter :email

  form html: { id: 'split_display_with_image' } do |f|
    f.inputs 'User avatar' do
      render 'admin/form/image_helper', f: f, field: :slickr_admin_user_avatar,
                                        label: 'Select user avatar'
      f.input :slickr_admin_user_avatar, as: :text
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
      link_to edit_admin_slickr_user_path do
        raw("<svg class='svg-icon'><use xlink:href='#svg-edit' /></svg>Edit user")
      end
    end
  end

  action_item :new_user, only: :index do
    link_to new_admin_slickr_user_path do
      raw("<svg class='svg-icon'><use xlink:href='#svg-plus' /></svg>Add user")
    end
  end

  controller do
    def create
      create! do |format|
        format.html do
          if resource.valid?
            redirect_to admin_slickr_user_path(resource), notice: 'User created'
          else
            render :new
          end
        end
      end
    end

    def update
      if params[:admin_user][:password].blank? &&
         params[:admin_user][:password_confirmation].blank?
        params[:admin_user].delete('password')
        params[:admin_user].delete('password_confirmation')
      end

      update! do |format|
        format.html do
          if resource.valid?
            redirect_to admin_slickr_user_path(resource), notice: 'User updated'
          else
            render :edit
          end
        end
      end
    end
  end
end
