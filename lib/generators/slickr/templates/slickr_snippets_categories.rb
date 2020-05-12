ActiveAdmin.register Slickr::SnippetsCategory do
  permit_params :title, :header

  filter :title
  index as: :reorderable_table do
    selectable_column
    column :title
    actions
  end

  form do |f|
    inputs do
      input :title
      input :header
    end
    actions
  end

  show do |snippet|
    attributes_table do
      row :title
      row :header
    end
  end
  controller do
    def permitted_params
      params.permit!
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
  collection_action :search_all_snippets_categories, method: :get do
    snippets_categories = SnippetsCategory.snippets_category_search(params[:snippet_string])
    render json: {
      snippetsCategories: snippets_categories.as_json(only: [:id, :slug, :title]),
      snippets_categories_loaded: true
    }.to_json
  end
end
