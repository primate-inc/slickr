class DraftjsExporter::Entities::StandardImage

  def call(parent_element, data)

    args = { src: '', class: '' }

    if data[:data][:display].nil? || data[:data][:display].to_sym == :full
      classNames = classNameBuilder(data)
      url = Slickr::MediaUpload.find(data[:data][:image][:id])
                              .image_url(:xl_limit)
      args = { src: url, class: classNames }
    else
      size = data[:data][:display].to_sym
      classNames = classNameBuilder(data)
      url = Slickr::MediaUpload.find(data[:data][:image][:id])
                                .image_url(size)
      args = { src: url, class: classNames }
    end

    args[:alt] = data[:data][:image][:additional_info][:alt_text]
    parent_element['class'] = data[:data][:classname]
    img = parent_element.document.create_element('img', args)
    parent_element.add_child(img)
  end

  def classNameBuilder(data)
    options = data[:data]
    [options[:appearance], options[:behaviour]].reject(&:empty?).join(" ")
  end
end
