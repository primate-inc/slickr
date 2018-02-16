class DraftjsExporter::Entities::Vimeo
  def call(parent_element, data)
    args = data[:data][:iframe]
    template = DraftjsExporter::Generators::VimeoGenerator.new(args).render
    parent_element.replace(template)
    parent_element
  end
end
