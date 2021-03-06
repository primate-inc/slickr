class DraftjsExporter::Entities::StandardImage
   def call(parent_element, data)
     image = Slickr::MediaUpload.find_by(id: data[:data][:image][:id])
     return if image.blank?
     srcset = [ [image.image_url(:content_1200), '1200w'],
                 [image.image_url(:content_800), '800w'],
                 [image.image_url(:content_600), '600w'],
                 [image.image_url(:content_400), '400w']].map{|e| e.join(' ')}.join(', ')

     additional = OpenStruct.new(data[:data][:image][:additional_info])
     args = {}
     args[:srcset] = srcset
     if data[:data][:display].present?
       args[:class] = "image_#{data[:data][:display].parameterize}"
     end
     args[:src] = image.image_url(:content_1200)
     args[:alt] = additional[:alt_text].present? ? additional[:alt_text] : ''
     args[:"data-img_caption"] = additional.try(:img_title)
     args[:"data-img_credit"] = additional.try(:img_credit)

     element = parent_element.document.create_element('img', args)
     parent_element.replace(element)
     element
  end
end
