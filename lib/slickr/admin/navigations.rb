include SlickrHelper
if defined?(ActiveAdmin)
  ActiveAdmin.register Slickr::Navigation do
    decorate_with Slickr::NavigationDecorator
    config.filters = true
    config.batch_actions = false
    menu priority: 3

    permit_params :parent_type, :child_type, :title, :image, :text, :link,
                  :link_text, :page_id, :parent_id

    breadcrumb do
      if params[:action] == 'index'
        [link_to('Admin', admin_root_path)]
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
             Hash[Slickr::Navigation.all.map { |nav| [nav.title, nav.title] }]
           },
           label: 'Navigation'

    form partial: 'new'
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

    index title: 'Navigation Tree', download_links: false do
      # binding.pry
      render partial: 'tree'
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
        merge_first_title_query if params[:q].nil?
        super
      end

      def create
        create! do |format|
          format.json { render json: @slickr_navigation.as_json(methods: [:admin_navigation_path]) }
        end
      end

      def show
        redirect_to admin_slickr_navigations_path(
          q: { title_eq: Slickr::Navigation.find(params[:id]).title }
        )
      end

      def merge_first_title_query
        params['q'] =
          {
            'title_eq' => Slickr::Navigation.find_by_title(
              Slickr::Navigation.first.title
            ).title
          }
      end
    end
  end
end
