class DraftjsExporter::Entities::Gallery
  def call(parent_element, data)
    gallery_items = data[:data][:gallery_items]
    args = gallery_items.map do |item|
      { image_id: item[:image].split('/')[1], caption: item[:caption] }
    end
    template = DraftjsExporter::Generators::GalleryGenerator.new(args).render
    parent_element.replace(template)
    parent_element
  end
end
