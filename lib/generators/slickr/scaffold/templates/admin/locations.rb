ActiveAdmin.register Location do
  config.sort_order = 'order_asc'
  config.paginate   = false
  reorderable

  permit_params :name, :address, :address_2, :phone,
                :email, :postcode, :country, :longitude,
                :latitude, :city, :published

  filter :name
  filter :city

  index as: :reorderable_table do
    selectable_column
    id_column
    column :name
    column :city
    actions
  end

  form do |f|
    inputs do
      input :name
      input :published,
            label: 'Show this location on website',
            hint: '',
            wrapper_html: { class: 'true_false'}
      input :address
      input :address_2
      input :city
      input :country
      input :postcode
      input :phone
      input :email
    end
    actions
  end
end
