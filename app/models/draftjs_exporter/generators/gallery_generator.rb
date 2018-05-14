require "erb"

class DraftjsExporter::Generators::GalleryGenerator
  def initialize contents
    @contents = contents
    @template = File.read "app/views/slickr_gallery_template/gallery.html.erb"
  end

  def render
    ERB.new(@template).result(binding)
  end
end
