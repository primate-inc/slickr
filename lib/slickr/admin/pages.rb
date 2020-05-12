include SlickrHelper
if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Page do
    include Slickr::SharedAdminActions

    includes :schedule
    menu priority: 1
    actions :all, except: :show
    before_action :set_paper_trail_whodunnit
    decorate_with Slickr::PageDecorator

    filter :title
    filter :layout

    index title: 'Pages', download_links: false do
      selectable_column
      id_column
      column :title
      column 'Layout' do |page|
        page.layout.humanize
      end
      # column 'State' do |page|
      #   page.aasm_state.humanize
      # end
      column 'Published' do |cs|
        cs.published?
      end
      actions
    end

    controller do
      include Slickr::SharedAdminController

      def create
        super do |format|
          create_resource_event_log(:create) if resource.valid?
          format.html do
            redirect_to edit_resource_url and return if resource.valid?
            render :new
          end
        end
      end

      def update
        update! do |format|
          create_resource_event_log(:update) if resource.valid?
          format.html do
            if resource.valid?
              redirect_to edit_admin_slickr_page_path(resource)
            else
              render :edit
            end
          end
        end
      end

      def destroy
        create_resource_event_log(:delete) if resource.valid?
        destroy! do |format|
          format.html do
            redirect_to admin_slickr_pages_path and return if resource.valid?
          end
        end
      end

      def scoped_collection
        Slickr::Page.not_draft
      end

      def user_for_paper_trail
        current_admin_user ? current_admin_user.id : 'Public user' # or whatever
      end

      def info_for_paper_trail
        { admin_id: current_admin_user.id } if current_admin_user
      end
    end

    member_action :create_draft, method: :post do
      draft = resource.create_draft
      if draft.valid?
        Slickr::EventLog.create(
          action: :create, eventable: draft, admin_user: current_admin_user
        )
      end
      redirect_to edit_resource_path
    end

    member_action :delete_draft, method: :delete do
      resource.delete_draft(draft_id)
      if draft.valid?
        Slickr::EventLog.create(
          action: :delete, eventable: draft, admin_user: current_admin_user
        )
      end
      redirect_to edit_resource_path
    end

  end

  private

  def create_resource_event_log(action)
    Slickr::EventLog.create(
      action: action, eventable: resource,
      admin_user: current_admin_user
    )
  end
end
