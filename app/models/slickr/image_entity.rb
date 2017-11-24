module Slickr
  class ImageEntity
     def call(parent_element, data)
       args = { src: data[:data][:image][:attachment][:small][:url] }
      #  args = { src: data.fetch(:data, {}).fetch(:url) }
       element = parent_element.document.create_element('img', args)
       parent_element.add_child(element)
       element
    end
  end
end
