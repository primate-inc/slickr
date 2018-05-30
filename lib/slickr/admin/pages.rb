include SlickrHelper
if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Page do
    menu priority: 1
    actions :all, except: :show
    before_action :set_paper_trail_whodunnit
    decorate_with Slickr::PageDecorator

    permit_params :page_title, :meta_description, :title, :page_intro,
                  :page_header, :page_subheader, :layout, :slug, :og_title,
                  :og_description, :twitter_title, :twitter_description,
                  :slickr_image_id, :remove_page_header_image, content: {}

    filter :title
    filter :layout

    index title: 'Pages', download_links: false do
      selectable_column
      id_column
      column :title
      column 'Layout' do |page|
        page.layout.humanize
      end
      column 'State' do |page|
        page.aasm_state.humanize
      end
      column 'Drafts' do |page|
        page.drafts.count
      end
      actions
    end

    form partial: 'edit'

    controller do
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
          format.html { redirect_to edit_admin_slickr_page_path(resource) }
          format.json do
            render json: @slickr_page.as_json(methods: [:admin_page_path])
          end
        end
      end

      def destroy
        create_resource_event_log(:delete) if resource.valid?
        destroy! do |format|
          format.html do
            redirect_to admin_slickr_pages_path and return if resource.valid?
          end
          format.json do
            render json: Slickr::Page.roots.not_draft.decorate.to_json(
              only: %i[id title],
              methods: %i[
                expanded subtitle edit_page_path published
                admin_delete_page_path
              ]
            )
          end
        end
      end

      def find_resource
        scoped_collection.friendly.find(params[:id])
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

    member_action :publish, method: :put do
      resource.publish! and Slickr::EventLog.create(action: :publish, eventable: resource, admin_user: current_admin_user) if resource.valid?
      respond_to do |format|
        format.html { redirect_to edit_resource_path, notice: "Published" }
        format.json { render json: @slickr_page.as_json }
      end
    end

    member_action :unpublish, method: :put do
      resource.unpublish! and Slickr::EventLog.create(action: :unpublish, eventable: resource, admin_user: current_admin_user) if resource.valid?
      respond_to do |format|
        format.html { redirect_to edit_resource_path, notice: "Unpublished" }
        format.json { render json: @slickr_page.as_json }
      end
    end

    member_action :create_draft, method: :post do
      draft = resource.create_draft
      Slickr::EventLog.create(action: :create, eventable: draft, admin_user: current_admin_user) if draft.valid?
      redirect_to edit_resource_path
    end

    member_action :delete_draft, method: :delete do
      resource.delete_draft(draft_id)
      Slickr::EventLog.create(action: :delete, eventable: draft, admin_user: current_admin_user) if draft.valid?
      redirect_to edit_resource_path
    end

    member_action :preview, method: :get do
      html_output = draftjs_to_html(resource, :content)
      render layout: false, template: "slickr_page_templates/#{resource.choose_template}", locals: {slickr_page: resource, content: html_output}
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
