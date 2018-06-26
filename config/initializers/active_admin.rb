ActiveAdmin.setup do |config|
  if defined? Webpacker
    config.register_javascript "#{Webpacker.manifest.lookup('slickr_text_area_editor.js')}"
    config.register_javascript "#{Webpacker.manifest.lookup('slickr_activeadmin_image_picker.js')}"
  end
end
