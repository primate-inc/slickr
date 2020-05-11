ActiveAdmin.register Slickr::Snippet do
  permit_params :title, :content, :header, :subheader, :published, :slickr_snippets_category_id,
                snippet_main_image_attributes: [:slickr_media_upload_id]

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
    actions
  end

  form do |f|
    if object.new_record?
      inputs do
        input :title
        input :slickr_snippets_category,
              label: 'Category',
              as: :select
      end
      actions
    else
      tabs do
        tab 'Content' do
          inputs do
            input :title
            input :header
            input :subheader
            input :slickr_snippets_category,
                  label: 'Category',
                  as: :select
            render 'admin/form/image_helper',
                   f: f,
                   field: :snippet_main_image
            input :snippet_main_image, as: :text
            render 'admin/form/text_area_helper', f: f, field: :content
            input :content, as: :text
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
end
