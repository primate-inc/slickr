# frozen_string_literal: true

# View helpers from Slickr

require 'redcarpet'

module SlickrHelper
  class CustomRender < Redcarpet::Render::HTML
    def paragraph(text)
      text
    end
  end

  include ActionView::Helpers::OutputSafetyHelper

  def format_with_markdown(content)
    renderer = SlickrHelper::CustomRender.new(filter_html: true, hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, {})
    markdown.render(content)
  end

  def format_with_full_markdown(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {})
    markdown.render(content)
  end

  def slickr_page_title
    [
      @slickr_page_title,
      @slickr_settings.try(:[], 'site_title')
    ].reject(&:blank?).join(' - ')
  end

  def slickr_meta_data(attr)
    meta = @slickr_settings.symbolize_keys.merge(compact_override || {})
    meta[attr].present? ? meta[attr] : ''
  end

  def draftjs_to_html(instance, field)
    exporter = DraftjsExporter::HTML.new(**Slickr::Page::DRAFTJS_CONFIG)
    content = if instance.send(field).class == String
                JSON.parse(instance.send(field))
              else
                instance.send(field)
              end
    restructure(content)
    raw(exporter.call(content.deep_symbolize_keys))
  end

  def slickr_editor_paths
    page = Slickr::Page.new
    form_json(page)
  end

  private

  def compact_override
    return unless @slickr_meta_override.respond_to?(:select)

    @slickr_meta_override.select do |_, value|
      value.present?
    end
  end

  def restructure(draftjs_content)
    atomic_blocks = []
    draftjs_content['blocks'].each_with_index do |block, index|
      if block['type'] == 'atomic'
        atomic_blocks << { block: block, index: index }
      end
    end

    atomic_blocks.each do |atomic_block|
      entity_key = SecureRandom.hex(3)

      draftjs_content['entityMap'][entity_key] = {
        data: atomic_block[:block]['data'],
        type: atomic_block[:block]['data']['type'].upcase,
        mutability: 'IMMUTABLE'
      }

      replacement_block = {
        'key' => atomic_block[:block]['key'],
        'data' => {},
        'text' => ' ',
        'type' => 'atomic',
        'depth' => 0,
        'entityRanges' => [
          {
            'key' => entity_key,
            'length' => 1,
            'offset' => 0
          }
        ],
        'inlineStyleRanges' => []
      }

      draftjs_content['blocks'][atomic_block[:index]] = replacement_block
    end
    atomic_blocks
  end

  def form_json(inst)
    inst.to_json(
      only: %i[
        admin_image_index_path additional_page_edit_paths
        admin_return_media_path
      ],
      methods: [
        :admin_image_index_path, :admin_return_media_path,
        inst.additional_page_edit_paths
      ].flatten
    )
  end
end
