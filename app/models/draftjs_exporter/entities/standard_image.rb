class DraftjsExporter::Entities::StandardImage
   def call(parent_element, data)

     if data[:data][:display].nil? || data[:data][:display].to_sym == :full
       url = Slickr::MediaUpload.find(data[:data][:image][:id])
                                .image_url(:xl_limit)
       args = { src: url }
     else
       size = data[:data][:display].to_sym
       url = Slickr::MediaUpload.find(data[:data][:image][:id])
                                .image_url(size)
       args = { src: url }
     end

     additional = OpenStruct.new(data[:data][:image][:additional_info])
     args[:alt] = additional[:alt_text].present? ? additional[:alt_text] : ''
     args[:"data-img_caption"] = additional.try(:img_title)
     args[:"data-img_credit"] = additional.try(:img_credit)

     element = parent_element.document.create_element('img', args)
     parent_element.replace(element)
     element
  end
end
