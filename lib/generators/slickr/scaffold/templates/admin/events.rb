# frozen_string_literal: true

# Main News Article Admin Interface
ActiveAdmin.register Event do
  include Slickr::SharedAdminActions
  includes :schedule
  # menu priority: 5
  actions :all
  config.sort_order = 'start_time_desc'

  permit_params do
    params = [
      :title, :date, :header, :subheader, :category, :header_image, :thumbnail,
      :content, :location, :start_time, :end_time,
      event_header_image_attributes: [:slickr_media_upload_id],
      event_thumbnail_attributes: [:slickr_media_upload_id]
    ]
    Slickr::PermitAdditionalAdminParams.push_to_params(Event, params)
    params
  end

  filter :title
  filter :featured
  filter :category, as: :select, collection: lambda {
    Hash[
      ::Event::CATEGORIES.map do |c|
        [I18n.t(c,
                scope: %i[
                  activerecord attributes events category_options
                ]), c]
      end
    ]
  }

  index do
    selectable_column
    id_column
    column :title
    column 'Start date' do |event|
      I18n.l(event.start_date, format: :long)
    end
    column 'Start time' do |event|
      I18n.l(event.start_time, format: :long)
    end
    column 'End date' do |event|
      I18n.l(event.end_date, format: :long)
    end
    column 'End time' do |event|
      I18n.l(event.end_time, format: :long)
    end
    column :category do |event|
      if event.category.nil? || event.category.empty?
        event.category
      else
        I18n.t(event.category,
               scope: %i[
                 activerecord attributes events category_options
               ])
      end
    end
    actions
  end

  show do |event|
    tabs do
      tab 'Details' do
        attributes_table do
          row :title
          row :featured
          row :location
          row :start_time do
            I18n.l(event.start_time, format: :long)
          end
          row :end_time do
            I18n.l(event.end_time, format: :long)
          end
          row :category do
            if event.category.nil? || event.category.empty?
              event.category
            else
              I18n.t(event.category,
                     scope: %i[
                       activerecord attributes events category_options
                     ])
            end
          end
          row :header
          row :subheader
          row :content do
            draftjs_to_html(event, :content) unless event.content.nil?
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
          input :location
          input :start_date,
                as: :datepicker,
                datepicker_options: {
                  dateFormat: 'dd-MM-yy'
                },
                input_html: { value: if f.object.new_record?
                                      Date.today.try(:strftime, '%d-%B-%Y')
                                    else
                                      f.object.start_date.try(:strftime, '%d-%B-%Y')
                                    end }
          input :start_time,
                as: :time_picker,
                wrapper_html: {
                  class: 'clockpicker', 'data-autoclose': 'true'
                },
                input_html: {
                  value: f.object.start_time.try(:strftime, '%H:%M')
                }
          input :end_date,
                as: :datepicker,
                datepicker_options: {
                  dateFormat: 'dd-MM-yy'
                },
                input_html: { value: if f.object.new_record?
                                      Date.today.try(:strftime, '%d-%B-%Y')
                                    else
                                      f.object.start_date.try(:strftime, '%d-%B-%Y')
                                    end }
          input :end_time,
                as: :time_picker,
                wrapper_html: {
                  class: 'clockpicker', 'data-autoclose': 'true'
                },
                input_html: {
                  value: f.object.end_time.try(:strftime, '%H:%M')
                }
          input :category,
                as: :select,
                collection: Hash[
                  ::Event::CATEGORIES.map do |c|
                    [I18n.t(c, scope: %i[
                              activerecord attributes events category_options
                            ]), c]
                  end]
          input :featured,
                label: 'Feature this event',
                hint: '',
                wrapper_html: { class: 'true_false'}
          render 'admin/form/image_helper',
                 f: f,
                 field: :event_header_image,
                 label: 'Header image'
          input :event_header_image, as: :text

          render 'admin/form/image_helper',
                 f: f,
                 field: :event_thumbnail,
                 label: 'Thumbnail'
          input :event_thumbnail, as: :text

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
           template: 'events/show',
           locals: { article: resource }
  end
  action_item :preview, only: %i[edit show] do
    link_to 'Preview', preview_admin_event_path(resource, article: resource)
  end
end
