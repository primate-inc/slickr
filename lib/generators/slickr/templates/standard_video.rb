class DraftjsExporter::Entities::StandardVideo
  def call(parent_element, data)
    args = { src: data.fetch(:data, {}).fetch(:src) }
    element = parent_element.document.create_element('video', args)
    parent_element.add_child(element)
    element
  end
end
