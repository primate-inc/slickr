# frozen_string_literal: true

# SlickrImageHelper module
module SlickrImageHelper
  # The Navigation image will override the page image if added.
  def slickr_nav_menu_image_builder(menu, size)
    nav_upload_id = menu[:image][:nav_upload_id]
    page_id = menu[:image][:page_id]
    if nav_upload_id.nil?
      Slickr::Page.find_by_id(page_id).header_image.image_url(size.to_sym)
    else
      Slickr::Upload.find_by_id(nav_upload_id)
                    .slickr_media_upload
                    .image_url(size.to_sym)
    end
  end

  def slickr_image_tag(image, args)
    return if image.nil? || args[:slickr].nil?
    build_picture(image, args)
  end

  private

  def build_picture(image, args)
    (
      '<picture class="slickr_image_tag">' +
      build_sources(image, args) * '' +
      build_image_tag(image, args) +
      '</picture>'
    ).html_safe
  end

  def build_sources(image, args)
    args[:slickr].map do |info|
      meta_data = image.image_data[info[:size].to_s]['metadata']
      aspect_ratio = (meta_data['height'].to_f / meta_data['width']).round(2)
      "<source media='(#{info.keys[0]}: #{info.values[0]})'
       srcset='#{image.image_url(info[:size])}'
       data-aspect_ratio='#{aspect_ratio}' />"
    end
  end

  def build_image_tag(image, args)
    image_tag_options = args.except(:slickr)
    image_tag_options['data-pagespeed-no-transform'] = nil
    image_tag_options['data-min_aspect_ratio'] = min_aspect_ratio(image, args)
    image_tag_options[:style] = 'background-color:white;'
    image_tag image.image_url(args[:slickr][0][:size]),
              image_tag_options
  end

  def min_aspect_ratio(image, args)
    aspect_ratio = 1
    args[:slickr].map do |info|
      meta_data = image.image_data[info[:size].to_s]['metadata']
      ar = (meta_data['height'].to_f / meta_data['width']).round(2)
      aspect_ratio = ar if ar < aspect_ratio
    end
    aspect_ratio
  end
end
