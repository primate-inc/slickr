# frozen_string_literal: true

# Main News Article Admin Interface
ActiveAdmin.register NewsArticle do
  include Slickr::SharedAdminActions
  includes :schedule
  # menu priority: 5
  actions :all
  config.sort_order = 'date_desc'

  permit_params do
    params = [
      :title, :date, :header, :subheader, :category, :header_image, :thumbnail,
      :content,
      news_header_image_attributes: [:slickr_media_upload_id],
      news_thumbnail_attributes: [:slickr_media_upload_id]
    ]
    Slickr::PermitAdditionalAdminParams.push_to_params(NewsArticle, params)
    params
  end

  filter :title
  filter :category, as: :select, collection: lambda do
    Hash[
      ::NewsArticle::CATEGORIES.map do |c|
        [I18n.t(c, scope: %i[activerecord attributes news category_options]), c]
      end
    ]
  end

  index do
    selectable_column
    id_column
    column :title
    column 'Date' do |news|
      I18n.l(news.date, :long)
    end
    column :category do |news|
      if news.category.nil? || news.category.empty?
        news.category
      else
        I18n.t(news.category,
               scope: %i[activerecord attributes news category_options])
      end
    end
    actions
  end

  show do |news|
    tabs do
      tab 'Details' do
        attributes_table do
          row :title
          row :date do
            I18n.l(news.date, :long)
          end
          row :category do
            if news.category.nil? || news.category.empty?
              news.category
            else
              I18n.t(news.category,
                     scope: %i[activerecord attributes news category_options])
            end
          end
          row :header
          row :subheader

          row :content do
            draftjs_to_html(news, :content) unless news.content.nil?
          end
        end
      end
    end
  end

  form do |f|
    tabs do
      tab 'Details' do
        inputs do
          input :title
          input :date,
                as: :datepicker,
                datepicker_options: {
                  dateFormat: 'dd-MM-yy'
                },
                input_html: { value: if f.object.new_record?
                                       Date.today.try(:strftime, '%d-%B-%Y')
                                     else
                                       f.object.date.try(:strftime, '%d-%B-%Y')
                                     end }
          input :category,
                as: :select,
                collection: Hash[
                  ::News::CATEGORIES.map do |c|
                    [I18n.t(c, scope: %i[activerecord attributes news category_options]), c]
                  end]

          render 'admin/form/image_helper',
                 f: f,
                 field: :news_header_image,
                 label: 'Header image'
          input :news_header_image, as: :text

          render 'admin/form/image_helper',
                 f: f,
                 field: :news_thumbnail,
                 label: 'Thumbnail'
          input :news_thumbnail, as: :text

          input :header
          input :subheader
          render 'admin/form/text_area_helper', f: f, field: :content
          f.input :content,
                  as: :text
        end
      end
      tab 'SEO' do
        render 'admin/form/meta_tag_seo_helper', f: f
      end
      tab 'Social Media' do
        render 'admin/form/meta_tag_social_helper', f: f
      end
      tab 'Schedule' do
        render 'admin/form/schedule_helper', f: f
      end
    end
    actions
  end

  controller do
    def permitted_params
      params.permit!
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
  member_action :preview, method: :get do
    html_output = draftjs_to_html(resource, :content)
    render layout: false,
           template: 'news_articles/show',
           locals: { article: resource }
  end
  action_item :preview, only: %i[edit show] do
    link_to 'Preview', preview_admin_news_path(resource, article: resource)
  end
end
