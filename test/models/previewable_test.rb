# frozen_string_literal: true

require 'test_helper'

class PreviewableTest < ActiveSupport::TestCase
  setup do
    @previewable_class = Slickr::Page.new(
      title: 'title',
      layout: 'standard',
      content: "{\"blocks\":[{\"key\":\"286ce4\",\"text\":\"text\",\"type\":\"unstyled\",\"depth\":0,\"inlineStyleRanges\":[],\"entityRanges\":[],\"data\":{}}],\"entityMap\":{}}"
    )
  end

  test 'has a template' do
    @previewable_class.slickr_previewable_template == ''
  end

  test 'has a layout' do
    @previewable_class.slickr_previewable_layout == ''
  end

  test 'has locales' do
    @previewable_class.slickr_previewable_locals == ''
  end

  test 'has instance variables' do
    @previewable_class.slickr_previewable_instance_variables == ''
  end
end
