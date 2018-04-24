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
    #  overridden in the React component
    breadcrumb do
      if params[:action] == 'index'
        [link_to('Admin', admin_root_path)]
      elsif params[:id]
        [
          link_to('Admin', admin_root_path),
          link_to(
            "#{Slickr::Navigation.find(params[:id]).title}",
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
             Hash[Slickr::Navigation.nav_roots.map { |nav| [nav.title, nav.title] }]
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
        super
      end

      def create
        create! do |format|
          format.json do
          end
        end
      end

      def show
        redirect_to admin_slickr_navigations_path(
          q: { title_eq: Slickr::Navigation.find(params[:id]).title }
        )
      end

      def edit
        nav = Slickr::Navigation.find(params[:id])
        return super if nav.root?
        params[:parent_id] = nav.parent.id
        page_selections
        super
      end

      def update
        update! do |format|
          format.json do
          end
        end
      end

      def merge_first_title_query
        params['q'] =
          {
            'title_eq' => Slickr::Navigation.find_by_title(
              Slickr::Navigation.first.title
            ).title
          }
      end

      def page_selections
        return @page_selections = selectable_pages if params[:id].nil?
        nav = Slickr::Navigation.find(params[:id])
        return @page_selections = selectable_pages if nav.child_type != 'Page'
        combine_results = selectable_pages | selected_nav_page(nav)
        @page_selections = combine_results.sort_by(&:title)
      end

      def selectable_pages
        root_type = Slickr::Navigation.find(params[:parent_id]).root.root_type
        case root_type
        when 'General'
          Slickr::Page.has_root_or_page_navs
        else
          Slickr::Page.no_root_or_page_navs
        end
      end

      def selected_nav_page(nav)
        Slickr::Page.where(id: nav.slickr_page.id)
      end
    end
  end
end
