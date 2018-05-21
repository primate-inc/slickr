include SlickrHelper
if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Page do
    decorate_with Slickr::PageDecorator
    before_action :set_paper_trail_whodunnit
    config.filters = false
    config.batch_actions = false
    menu priority: 1
    permit_params :page_title, :meta_description, :title, :page_intro,
                  :page_header, :page_subheader, :layout, :parent_id,
                  :slug, :page_header_image, :og_title, :og_description,
                  :twitter_title, :twitter_description, :slickr_image_id,
                  :remove_page_header_image, content: {}

    breadcrumb do
      if params[:action] == 'index'
        [ link_to('Admin', admin_root_path) ]
      else
        [
          link_to('Admin', admin_root_path),
          link_to('Pages', admin_slickr_pages_path),
        ]
      end
    end

    form :partial => "edit"
    config.clear_action_items!

    action_item :new_page, only: :index do
      link_to new_admin_slickr_page_path do
        raw("<svg class='svg-icon'><use xlink:href='#svg-plus' /></svg>Add page")
      end
    end

    index title: 'Pages', download_links: false do |page|
      render partial: 'dashboard'
    end

    controller do
      def find_resource
        scoped_collection.friendly.find(params[:id])
      end
      def create
        super do |format|
          Slickr::EventLog.create(action: :create, eventable: resource, admin_user: current_admin_user) if resource.valid?
          redirect_to edit_resource_url and return if resource.valid?
        end
      end

      def update
        super do |format|
          Slickr::EventLog.create(action: :update, eventable: resource, admin_user: current_admin_user) if resource.valid?
          redirect_to edit_resource_url and return if resource.valid?
        end
      end

      def destroy
        Slickr::EventLog.create(action: :delete, eventable: resource, admin_user: current_admin_user) if resource.valid?
        destroy! do |format|
          format.html { redirect_to edit_resource_url and return if resource.valid? }
          format.json { render json: Slickr::Page.roots.not_draft.decorate.to_json(only: [:id, :title], methods: [:expanded, :subtitle, :edit_page_path, :add_child_path, :children, :published, :admin_delete_page_path]) }

        end
      end
    end

    member_action :change_position, method: :put do
      resource.update_attribute(:parent_id, params[:parent_id])
      if params[:previous_id].present?
        previous = Slickr::Page.find(params[:previous_id])
        if resource.position < previous.position
          resource.insert_at(previous.position.to_i)
        else
          resource.insert_at(previous.position.to_i  + 1)
        end
      else
        resource.move_to_top
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

    controller do
      def update
        update! do |format|
          format.html { redirect_to edit_admin_slickr_page_path(resource) }
          format.json { render json: @slickr_page.as_json(methods: [:admin_page_path]) }
        end
      end

      def edit
        super do |format|
          # resource.build_content_area if resource.content_areas.empty?
        end
      end


      def user_for_paper_trail
        current_admin_user ? current_admin_user.id : 'Public user'  # or whatever
      end

      def info_for_paper_trail
        { admin_id: current_admin_user.id } if current_admin_user
      end
    end
  end
end
