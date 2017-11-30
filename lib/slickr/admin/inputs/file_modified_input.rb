class FileModifiedInput < Formtastic::Inputs::FileInput
  def to_html
    input_wrapping do
      builder.file_field(method, input_html_options) <<
      label_html <<
      template.content_tag(:span,"", class: 'file_name')
    end
  end
end
