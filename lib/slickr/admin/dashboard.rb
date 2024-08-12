include ActiveAdmin::DashboardHelper

ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  breadcrumb do
    []
  end

  content do
    render partial: 'dashboard', locals: {greeting: time_of_day_greeting}
  end
end
