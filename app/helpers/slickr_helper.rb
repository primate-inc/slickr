module SlickrHelper
  def draftjs_to_html(instance, field)
    binding.pry
    exporter = DraftjsExporter::HTML.new(Slickr::Page::DRAFTJS_CONFIG)
    restructure(instance.send(field))
    exporter.call(instance.send(field).deep_symbolize_keys)
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
end
