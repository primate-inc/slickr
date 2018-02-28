class DraftjsExporter::Entities::StandardImage
   def call(parent_element, data)
     if data[:data][:display].nil? || data[:data][:display].to_sym == :full
       args = { src: data[:data][:image][:attachment][:url] }
     else
       size = data[:data][:display].to_sym
       args = { src: data[:data][:image][:attachment][size][:url] }
     end
     args[:alt] = data[:data][:image][:data][:alt_text]
     element = parent_element.document.create_element('img', args)
     parent_element.replace(element)
     element
  end
end
