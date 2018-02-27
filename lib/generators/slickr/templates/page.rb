require_dependency Slickr::Engine.config.root.join('app', 'models', 'slickr', 'page.rb').to_s

class Slickr::Page
  LAYOUTS = ["standard", "contact", "landing"]

  DRAFTJS_CONFIG = {
    entity_decorators: {
      'LINK' => DraftjsExporter::Entities::Link.new(className: 'link'),
      'IMAGE' => DraftjsExporter::Entities::StandardImage.new,
      'VIMEO' => DraftjsExporter::Entities::Vimeo.new,
      'YOUTUBE' => DraftjsExporter::Entities::YouTube.new,
      'PDF_LINK' => DraftjsExporter::Entities::Link.new(className: 'pdf__link'),
    },
    block_map: {
      'header-one'          => { element: 'h1' },
      'header-two'          => { element: "h2" },
      'header-three'        => { element: "h3" },
      'header-four'         => { element: "h4" },
      'unordered-list-item' => {
        element: 'li',
        wrapper: ['ul', { className: 'public-DraftStyleDefault-ul' }]
      },
      'ordered-list-item'   => {
        element: 'li',
        wrapper: ['ol', { className: 'public-DraftStyleDefault-ol' }]
      },
      "blockquote"          => { element: "blockquote" },
      "code-block"          => { element: "pre" },
      'unstyled'            => { element: 'p' },
      'atomic'              => { element: 'div' }
    },
    style_map: {
      'UNDERLINE'           => { fontStyle: 'underline' },
      'ITALIC'              => { fontStyle: 'italic' },
      'BOLD'                => { fontStyle: 'bold' }
    }
  }

  def additional_page_edit_paths
    [:admin_user_index_path]
  end

  private

  def admin_user_index_path
    Rails.application.routes.url_helpers.admin_admin_users_path(type: 'megadraft_admins')
  end
end
