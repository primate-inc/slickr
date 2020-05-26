include ActiveAdmin::DashboardHelper

ActiveAdmin.register_page "Rubbish" do
  menu priority: 100, label: proc{ I18n.t("active_admin.rubbish") }
  breadcrumb do
    []
  end

  content do
    render partial: 'rubbish'
  end
  controller do
    def index
      filter_method = params[:filter].present? ? params[:filter].to_sym : :slickr_pages
      @collection = Slickr::Rubbish.send(filter_method)
    end
  end
end
