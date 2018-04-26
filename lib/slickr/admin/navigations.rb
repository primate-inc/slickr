include SlickrHelper
if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Navigation do
    decorate_with Slickr::NavigationDecorator
    config.filters = true
    config.batch_actions = false
    menu priority: 3

    permit_params :root_type, :child_type, :title, :image, :text, :link,
                  :link_text, :page_id, :parent_id, :slickr_page_id

    # breadcrumbs only used for tree roots. All child breadcrumbs are
    # overridden in the React component
    breadcrumb do
      if params[:action] == 'index'
        [link_to('Admin', admin_root_path)]
      elsif params[:id]
        [
          link_to('Admin', admin_root_path),
          link_to(
            Slickr::Navigation.find(params[:id]).title,
            admin_slickr_navigation_path(params[:id])
          )
        ]
      else
        [
          link_to('Admin', admin_root_path),
          link_to('Navigation Tree', admin_slickr_navigations_path)
        ]
      end
    end

    filter :title,
           as: :select,
           collection: lambda {
             Hash[
               Slickr::Navigation.nav_roots.map { |nav| [nav.title, nav.title] }
             ]
           },
           label: 'Navigation'

    index title: 'Navigation Tree', download_links: false do
      render partial: 'tree'
    end

    form partial: 'form'

    config.clear_action_items!
    action_item :new_page, only: %i[index show] do
      link_to new_admin_slickr_navigation_path do
        raw(
          "<svg class='svg-icon'>
            <use xlink:href='#svg-plus' />
          </svg>Add Navigation"
        )
      end
    end

    member_action :change_position, method: :put do
      resource.update_attribute(:parent_id, params[:parent_id])
      if params[:previous_id].present?
        previous = Slickr::Navigation.find(params[:previous_id])
        if resource.position < previous.position
          resource.insert_at(previous.position.to_i)
        else
          resource.insert_at(previous.position.to_i + 1)
        end
      else
        resource.move_to_top
      end
    end

    controller do
      def index
        return super if params[:q].present?
        return super if Slickr::Navigation.all.count.zero?
        merge_first_title_query
        super
      end

      def new
        return super unless params[:parent_id]
        page_selections
        root_nav
        super
      end

      def create
        create! do |format|
          format.json do
            render json: {}
          end
        end
      end

      def show
        redirect_to admin_slickr_navigations_path(
          utf8: '✓',
          q: { title_eq: Slickr::Navigation.find(params[:id]).title }
        )
      end

      def edit
        nav = Slickr::Navigation.find(params[:id])
        return super if nav.root?
        params[:parent_id] = nav.parent.id
        page_selections
        root_nav
        super
      end

      def update
        update! do |format|
          format.json do
            render json: {}
          end
        end
      end

      def destroy
        link_child_nav_ids = link_child_navs_to_delete
        page_root_nav_ids = page_root_navs_to_delete
        destroy! do |format|
          format.json do
            unless link_child_nav_ids.nil?
              Slickr::Navigation.where(id: link_child_nav_ids).destroy_all
            end
            unless page_root_nav_ids.nil?
              Slickr::Navigation.where(id: page_root_nav_ids).destroy_all
            end
            render json: Slickr::Navigation.where(title: params[:root_title])
              .decorate.to_json(
                only: %i[id title], methods: %i[
                  expanded subtitle admin_edit_navigation_path
                  add_child_path children admin_delete_navigation_path
                ]
              )
          end
        end
      end

      # inject params so index only shows the tree of the first root nav
      def merge_first_title_query
        params['q'] =
          {
            'title_eq' => Slickr::Navigation.find_by_title(
              Slickr::Navigation.first.title
            ).title
          }
        params['utf8'] = '✓'
      end

      def page_selections
        return @page_selections = selectable_pages if params[:id].nil?
        nav = Slickr::Navigation.find(params[:id])
        return @page_selections = selectable_pages if nav.child_type != 'Page'
        combine_results = selectable_pages | selected_nav_page(nav)
        @page_selections = combine_results.sort_by(&:title)
      end

      # root_types of Link can only have child pages where the pages already
      # exists in the nav structure of the site. Other root types can only
      # create child pages where the page does not exist in the nav structure
      # of the site
      def selectable_pages
        root_type = Slickr::Navigation.find(params[:parent_id]).root.root_type
        case root_type
        when 'Link'
          Slickr::Page.has_root_or_page_navs
        else
          Slickr::Page.no_root_or_page_navs
        end
      end

      # used when editing a nav object to make sure the page that was already
      # save is still present in the drop down of selectable pages
      def selected_nav_page(nav)
        Slickr::Page.where(id: nav.slickr_page.id)
      end

      # extract title and build url for the root nav of any nav
      def root_nav
        nav = Slickr::Navigation.find(params[:parent_id]).root
        @root_nav = {
          title:  nav.title,
          url:    admin_slickr_navigations_path(
            utf8: '✓',
            q: { 'title_eq' => nav.title }
          )
        }
      end

      # if the deleted navigation child is a Page and its root is not 'Link'
      # then delete the descendants of all roots of type 'Link' that have
      # the same slickr_page_id as the deleted navigation child
      #
      # returns an array of ids
      def link_child_navs_to_delete
        nav = Slickr::Navigation.find(params[:id])
        return unless nav.child_type == 'Page'
        return if nav.root.root_type == 'Link'
        build_link_child_nav_ids_to_delete(nav)
      end

      def build_link_child_nav_ids_to_delete(nav)
        link_page_navs_to_delete = []

        link_roots = Slickr::Navigation.where(root_type: 'Link')
        link_roots.each do |gr|
          ids_to_delete = gr.descendants.map do |d|
            d.id if d.slickr_page_id == nav.slickr_page_id
          end.compact
          link_page_navs_to_delete += ids_to_delete
        end
        link_page_navs_to_delete
      end

      # if the deleted navigation child is a Page then check all root_types of
      # Page and delete if they have the same slickr_page_id as the deleted
      # navigation child
      #
      # returns an array of ids
      def page_root_navs_to_delete
        nav = Slickr::Navigation.find(params[:id])
        return unless nav.child_type == 'Page'
        Slickr::Navigation.select(:id).where(
          root_type: 'Page', slickr_page_id: nav.slickr_page_id
        ).pluck(:id)
      end
    end
  end
end
