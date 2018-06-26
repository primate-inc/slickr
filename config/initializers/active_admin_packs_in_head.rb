module ActiveAdmin
  module Views
    module Pages
      class Base < Arbre::HTML::Document
        alias_method :original_build_head, :build_active_admin_head

        def build_active_admin_head
          original_build_head

          within @head do
            script src: "#{Webpacker.manifest.lookup('slickr_text_area_editor.js')}"
            script src: "#{Webpacker.manifest.lookup('slickr_activeadmin_image_picker.js')}"
          end
        end
      end
    end
  end
end
