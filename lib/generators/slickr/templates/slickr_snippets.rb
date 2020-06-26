ActiveAdmin.register Slickr::Snippet do
  include Slickr::SharedAdminActions
  permit_params :title, :content, :header, :subheader, :published, :slickr_snippets_category_id,
                :kind, snippet_main_image_attributes: [:slickr_media_upload_id]

  config.sort_order = 'position_asc'
  config.paginate   = false
  reorderable

  filter :title
  filter :slickr_snippets_category, label: 'Category', as: :select
  index as: :reorderable_table do
    selectable_column
    id_column
    column :title
    column 'Category', :slickr_snippets_category
    actions defaults: false do |snippet|
      item "Edit", edit_admin_slickr_snippet_path(snippet)
      item "Delete", discard_admin_slickr_snippet_path(snippet)
    end
  end

  form do |f|
    if object.new_record?
      inputs do
        input :title
        input :kind, as: :select, collection: Slickr::Snippet::KINDS.map { |k| k[:kind] }
        input :slickr_snippets_category,
              label: 'Category',
              as: :select
      end
      actions
    else
      snippet_type = Slickr::Snippet::KINDS.find do |kind|
        kind[:kind] == object.kind
      end
      exclude_fields = snippet_type[:exclude] ? snippet_type[:exclude] : []
      tabs do
        tab 'Content' do
          inputs do
            input :title
            input :slickr_snippets_category,
                  label: 'Category',
                  as: :select
            input :header
            unless :subheader.in? exclude_fields
              input :subheader
            end
            unless :image.in? exclude_fields
              render 'admin/form/image_helper',
                     f: f,
                     field: :snippet_main_image
              input :snippet_main_image, as: :text
            end
            unless :wysiwyg.in? exclude_fields
              render 'admin/form/text_area_helper', f: f, field: :content
              input :content, as: :text
            end
            input :published,
                  wrapper_html: { class: 'true_false' }
          end
        end
      end
      actions
    end
  end
  show do |snippet|
    attributes_table do
      row :title
      row :snippet_main_image do
        image_tag snippet.main_image.image_url(:original) if snippet.main_image.present?
      end
      row :header
      row :subheader
      row :kind, as: 'Category' do
        snippet.kind.to_s.humanize
      end
      row :content do
        draftjs_to_html(snippet, :content) unless snippet.content.nil?
      end
    end
  end
  controller do
    include Slickr::SharedAdminController
    def scoped_collection
      if ['restore', 'destroy'].include?(params[:action])
        end_of_association_chain.discarded
      else
        end_of_association_chain.kept
      end
    end
  end
end
