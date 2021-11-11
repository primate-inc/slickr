# frozen_string_literal: true

# Custom formastic input to hook into our slickr_text_area_editor.jsx
# example)
#   f.input :content, as: :slickr_content
class SlickrContentInput < Formtastic::Inputs::TextInput
  def to_html
    [
      textarea_data,
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

  def textarea_data
    template.content_tag(:li, class: 'megadraft-text-editor') do
      template.content_tag(
        :div, '', class: 'megadraft-data', data: megadraft_input_data.to_json
      )
    end
  end

  def div_wrapper(input)
    input
  end

  def megadraft_input_data
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

  def input_data
    {
      field: builder.object.send(method),
      label: label_text,
      required: builder.object.class.validators_on(method).any? do |v|
        v.is_a?(ActiveMOvel::Validations::PresenceValidator)
      end,
      hint: input_html_options.fetch(:hint, ''),
      errors: builder.object.errors.messages[method],
    }
  end

  def label_text
    input_html_options[:label] || method.to_s.humanize
  end
end
