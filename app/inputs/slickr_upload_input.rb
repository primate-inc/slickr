# frozen_string_literal: true

# Custom formastic input to hook into our slickr_activeadmin_image_picker.jsx
# example)
#   f.input :image, as: :slickr_upload
class SlickrUploadInput < Formtastic::Inputs::TextInput
  def to_html
    [
      upload_data,
      input_wrapping do
        label_html << builder.text_area(method, input_html_options.merge(class: 'text'))
      end,
    ].join.html_safe
  end

  def wrapper_html_options
    opts = super
    opts[:class] = opts[:class] << ' text'
    opts
  end

  private

  def upload_data
    template.content_tag(:li, class: 'image-picker') do
      template.content_tag(
        :div, '', class: 'image-data', data: slickr_uploadable_input_data.to_json
      )
    end
  end

  def div_wrapper(input)
    input
  end

  def slickr_uploadable_input_data
    {
      input: input_data,
      tags: [
        builder.object.model_name.element.gsub(/^slickr_/, ''),
        method.to_s.gsub(builder.object.model_name.param_key, '').humanize.parameterize.underscore,
      ],
      pageState: slickr_editor_paths,
      allowedUploadInfo: Slickr::MediaUpload.allowed_upload_info,
      additionalInfo: Slickr::MediaUpload.additional_info,
    }
  end

  # rubocop:disable Metrics/AbcSize
  def input_data
    {
      id: builder.object.send(method)&.slickr_media_upload&.id,
      field: object_id,
      path: builder.object.send(method)&.slickr_media_upload&.image_url(:thumb_200x200),
      label: label_text,
      required: builder.object.class.validators
                       .select { |v| v.is_a?(SlickrImagePresentValidator) }
                       .find { |v| v.options[:method_symbol] == method }
                       .options[:required],
      hint: input_html_options.fetch(:hint, ''),
      errors: builder.object.errors.messages[method],
    }
  end
  # rubocop:enable Metrics/AbcSize

  def label_text
    (input_html_options[:label] || method.to_s.humanize)
  end
end
