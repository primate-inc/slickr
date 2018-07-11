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

  def slickr_picture_tag(image, options = {}, &block)
    return if image.nil?
    content_tag :picture, picture_options(options) do
      "<!--[if IE 9]><video style='display: none;'><![endif]-->".html_safe +
        capture(&block).html_safe +
        '<!--[if IE 9]></video><![endif]-->'.html_safe +
        tag('img', image_options(image, options))
    end
  end

  def slickr_source_tag(options = {})
    tag :source, options
  end

  private

  def picture_options(options)
    picture_options_to_ignore = %i[image version]
    options.except(*picture_options_to_ignore)
  end

  def image_options(image, options)
    image_options = options.fetch(:image, {})
    image_options[:srcset] = image.image_url(options[:version])
    image_options
  end
end
