# frozen_string_literal: true

require 'test_helper'
class DummyTestClass
  extend ActiveModel::Naming
  include Slickr::Previewable
  slickr_previewable
end

class OverridenTestClass
  extend ActiveModel::Naming
  include Slickr::Previewable
  slickr_previewable(
    template: lambda { |p| "slickr_page_templates/#{p.layout}" },
    locals: lambda { |p| { self_local: p, content: 'test content' } },
    instance_variables: {test: 'test'},
    layout: false
  )

  def layout
    'overriden'
  end
end

class PreviewableTest < ActiveSupport::TestCase
  setup do
    @default_previewable_class = DummyTestClass.new
    @overriden_previewable_class = OverridenTestClass.new
  end

  test 'has a default template' do
    assert_equal 'dummy_test_classes/show', @default_previewable_class.slickr_previewable_template
  end

  test 'has a default layout' do
    assert_equal 'layouts/application', @default_previewable_class.slickr_previewable_layout
  end

  test 'has default locales' do
    assert_equal({}, @default_previewable_class.slickr_previewable_locals)
  end

  test 'has default instance variables' do
    assert_equal [], @default_previewable_class.slickr_previewable_instance_variables
  end

  test 'has overriden template' do
    assert_equal 'slickr_page_templates/overriden', @overriden_previewable_class.slickr_previewable_template
  end

  test 'has overriden layout' do
    assert_equal false, @overriden_previewable_class.slickr_previewable_layout
  end

  test 'has overriden locales' do
    assert_equal({self_local: @overriden_previewable_class, content: 'test content'}, @overriden_previewable_class.slickr_previewable_locals)
  end

  test 'has overriden instance variables' do
    assert_equal({test: 'test'}, @overriden_previewable_class.slickr_previewable_instance_variables)
  end
end
