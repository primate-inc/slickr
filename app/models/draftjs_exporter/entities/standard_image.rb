class DraftjsExporter::Entities::StandardImage
   def call(parent_element, data)
     size = data[:data][:display].to_sym
     if size == :full
       args = { src: data[:data][:image][:attachment][:url] }
     else
       args = { src: data[:data][:image][:attachment][size][:url] }
     end
     element = parent_element.document.create_element('img', args)
     parent_element.replace(element)
     element
  end
end
