ActiveAdmin.setup do |config|
  config.register_javascript "#{Webpacker.manifest.lookup('slickr_text_area_editor.js')}"
end
