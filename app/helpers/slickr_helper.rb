include ActionView::Helpers::OutputSafetyHelper

module SlickrHelper
  def draftjs_to_html(instance, field)
    exporter = DraftjsExporter::HTML.new(Slickr::Page::DRAFTJS_CONFIG)
    content = instance.send(field).class == String ? JSON.parse(instance.send(field)) : instance.send(field)
    restructure(content)
    raw(exporter.call(content.deep_symbolize_keys))
  end

  def slickr_editor_paths
    page = Slickr::Page.new
    form_json(page)
  end

  def main_navigation_pages
    home_page = Slickr::Page.find_by_slug('home')
    home_page.nil? ? [] : home_page.children.where(aasm_state: :published).order(:position)
  end

  def footer_navigation_pages
    footer = Slickr::Page.find_by_slug('footer')
    footer.nil? ? [] : footer.children.where(aasm_state: :published).order(:position)
  end

  private

  def restructure(draftjs_content)
    atomic_blocks = []
    draftjs_content["blocks"].each_with_index { |block, index| atomic_blocks << {block: block, index: index} if block['type'] == 'atomic' }

    atomic_blocks.each do |atomic_block|
      entity_key = SecureRandom.hex(3)

      draftjs_content["entityMap"][entity_key] = {
        data: atomic_block[:block]["data"],
        type: atomic_block[:block]["data"]["type"].upcase,
        mutability: "IMMUTABLE"
      }

      replacement_block = {
        "key" => atomic_block[:block]["key"],
        "data" => {},
        "text" => " ",
        "type" => "atomic",
        "depth" => 0,
        "entityRanges" => [
          {
            "key" => entity_key,
            "length" => 1,
            "offset" => 0
          }
        ],
        "inlineStyleRanges" => []
      }

      draftjs_content["blocks"][atomic_block[:index]] = replacement_block
    end
    atomic_blocks
  end

  def form_json(inst)
    inst.to_json(only:  [:admin_image_index_path, :additional_page_edit_paths],
                        methods: [
                          :admin_image_index_path,
                          inst.additional_page_edit_paths
                        ].flatten)
  end
end
