class DraftjsExporter::Entities::YouTube
  def call(parent_element, data)
    args = data[:data][:iframe]
    template = DraftjsExporter::Generators::YouTubeGenerator.new(args).render
    parent_element.replace(template)
    parent_element
  end
end
