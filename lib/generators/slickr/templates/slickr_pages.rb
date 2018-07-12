ActiveAdmin.register Slickr::Page do
  permit_params :page_title, :meta_description, :title, :page_intro,
                :page_header, :page_subheader, :layout, :slug, :og_title,
                :og_description, :twitter_title, :twitter_description,
                :content, :slug,
                slickr_page_header_image_attributes: [:slickr_media_upload_id]

  form do |f|
    if object.new_record?
      inputs do
        input :title
        input :layout, collection: options_for_select(
          Slickr::Page::LAYOUTS.map do |l|
            [l[:template].humanize, l[:template]]
          end
        )
      end
      actions
    else
      tabs do
        tab 'Content' do
          inputs do
            input :title
            input :page_header, as: :text
            render 'admin/form/image_helper',
                   f: f,
                   field: :slickr_page_header_image
            input :slickr_page_header_image, as: :text
            input :page_subheader, as: :text
            input :page_intro, as: :text
            render 'admin/form/text_area_helper', f: f, field: :content
            input :content, as: :text
          end
        end
        tab 'SEO' do
          inputs do
            input :page_title
            input :meta_description, as: :text
          end
        end
        tab 'Social Media' do
          inputs do
            input :og_title, as: :string, label: 'Facebook og title'
            input :og_description, as: :text, label: 'Facebook og description'
            input :twitter_title, as: :string
            input :twitter_description, as: :text
          end
        end
        tab 'Config' do
          inputs do
            input :layout,
                  as: :select,
                  collection: (Slickr::Page::LAYOUTS.map do |l|
                    [l[:template].humanize, l[:template]]
                  end)
            input :slug
          end
        end
      end
      actions
    end
  end
end
