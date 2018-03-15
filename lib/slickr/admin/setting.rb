ActiveAdmin.register_page 'Settings' do
  title = 'Settings'
  menu label: title

  active_admin_settings_page(
    title: title,
    model_name: 'Slickr::Setting',
    template: 'admin/slickr_settings/index'
  )
end
