ActiveAdmin.register Person do
  include Slickr::SharedAdminActions
  config.sort_order = 'order_asc'
  config.paginate   = false
  reorderable
  menu priority: 4
  actions :all, except: :show

  permit_params :first_name, :last_name, :position, :phone, :email, :published, :instagram,
                :facebook, :twitter, :linkedin,
                :category, :description, person_photo_attributes: [:slickr_media_upload_id]

  filter :first_name
  filter :last_name

  index as: :reorderable_table do
    selectable_column
    id_column
    column :first_name
    column :last_name
    actions
  end

  show do |person|
    tabs do
      tab 'Basic info' do
        row :first_name
        row :last_name
        row :position
        row :category
        row :phone
        row :email
        row :photo do
          if person.photo.present?
            image_tag person.photo.image_url(:m_limit)
          end
        end
        row :description
      end
      tab 'Social' do
        row :linkedin
        row :facebook
        row :twitter
        row :instagram
      end
    end
  end

  form do |f|
    tabs do
      tab 'Basic info' do
        inputs do
          input :first_name
          input :last_name
          input :position
          input :phone
          input :email
          input :published,
                label: 'Show this person on website',
                hint: '',
                wrapper_html: { class: 'true_false'}
          input :category,
                as: :select,
                collection: Hash[
                  ::Person::CATEGORIES.map do |c|
                    [I18n.t(c, scope: %i[
                              activerecord attributes people category_options
                            ]), c]
                  end]
          render 'admin/form/image_helper',
                  f: f,
                  field: :person_photo,
                  label: 'Photo',
                  hint: 'Any hint text you need'
          input :person_photo, as: :text
          render 'admin/form/text_area_helper', f: f, field: :description
          input :description, as: :text
        end
      end
      tab 'Social profiles' do
        inputs do
          input :linkedin
          input :twitter
          input :facebook
          input :instagram
        end
      end
      tab 'SEO' do
        render 'admin/form/meta_tag_seo_helper', f: f
      end
      tab 'Social Media' do
        render 'admin/form/meta_tag_social_helper', f: f
      end
    end
    actions
  end

  controller do
    def permitted_params
      params.permit!
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

end
