class DraftjsExporter::Entities::StandardImage
   def call(parent_element, data)
     size = data[:data][:display].to_sym
     args = { src: data[:data][:image][:attachment][size][:url] }
     element = parent_element.document.create_element('img', args)
     parent_element.replace(element)
     element
  end
end
