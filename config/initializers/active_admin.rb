ActiveAdmin.setup do |config|
  if defined? Webpacker
    config.register_javascript "#{Webpacker.manifest.lookup('slickr_text_area_editor.js')}"
  end
end
