require_dependency Slickr::Engine.config.root.join('app', 'models', 'slickr', 'page.rb').to_s

class Slickr::Page
  LAYOUTS = [
    { template: "standard", exclude: [:page_header, :page_subheader, :page_intro] },
    { template: "contact", exclude: [] },
    { template: "landing", exclude: [] }
  ]

  DRAFTJS_CONFIG = {
    entity_decorators: {
      'LINK' => DraftjsExporter::Entities::Link.new(className: 'link'),
      'IMAGE' => DraftjsExporter::Entities::StandardImage.new,
      'VIMEO' => DraftjsExporter::Entities::Vimeo.new,
      'YOUTUBE' => DraftjsExporter::Entities::YouTube.new,
      'PDF_LINK' => DraftjsExporter::Entities::TargetBlankLink.new(className: 'pdf__link'),
    },
    block_map: {
      'header-one'          => { element: 'h1' },
      'header-two'          => { element: "h2" },
      'header-three'        => { element: "h3" },
      'header-four'         => { element: "h4" },
      'header-five'         => { element: "h5" },
      'header-six'         => { element: "h6" },
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
    [:admin_pdfs_path]
  end

  private

  def admin_pdfs_path
    Rails.application.routes.url_helpers.admin_slickr_images_path(type: 'megadraft_pdfs')
  end
end
