ActiveAdmin.register AdminUser, as: "Users" do
  includes :admin_user_avatar

  menu priority: 100
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :role

  scope :all, default: true

  config.clear_action_items!

  index do |resource|
    selectable_column
    column '' do |user|
      if user.admin_user_avatar
        image_tag user.admin_user_avatar.image_url(:thumb_fill),
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
      if resource.admin_user_avatar.present?
        div class: 'image' do
          image_tag resource.admin_user_avatar.image_url(:m_limit)
        end
      end
      f.input :admin_user_avatar, as: :file, label: 'Select user avatar'
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
    def create
      create! do |format|
        create_media_upload_and_polymorphic

        format.html { redirect_to admin_user_path(resource), notice: 'User created' }
      end
    end

    def update
      if params[:admin_user][:password].blank? && params[:admin_user][:password_confirmation].blank?
        params[:admin_user].delete('password')
        params[:admin_user].delete('password_confirmation')
      end

      update! do |format|
        create_media_upload_and_polymorphic

        format.html { redirect_to admin_user_path(resource), notice: 'User updated' }
      end
    end

    def create_media_upload_and_polymorphic
      return unless params[:admin_user][:admin_user_avatar]
      avatar = params[:admin_user][:admin_user_avatar].tempfile
      filename = params[:admin_user][:admin_user_avatar].original_filename

      media = Slickr::MediaUpload.new
      media.image = avatar
      media.image_data
      media.image_data['metadata']['filename'] = filename
      media.save

      resource.build_slickr_admin_user_avatar(slickr_media_upload_id: media.id).save
    end
  end

end
